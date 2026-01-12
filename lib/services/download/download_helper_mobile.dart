import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:bapa_sitaram/services/app_events.dart';
import 'package:bapa_sitaram/services/enums.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/services/loger_service.dart';

class DownloadMessage {
  DownloadMessage({required this.url, required this.progress, this.filePath});
  final double progress;
  final String url;
  final String? filePath;
}

class DownloadServiceMobile {
  Future<String?> download({required String url, bool keepOriginalName = false}) async {
    final receivePort = ReceivePort();
    String path = '';
    try {
      String downloadPath = await HelperService().getDownloadDirectory();

      final directory = Directory('$downloadPath/bapaSitaram');
      bool isExist = await directory.exists();
      if (!isExist) {
        await directory.create(recursive: false);
      }
      Map<String, dynamic> param = {'url': url, 'sendPort': receivePort.sendPort, 'path': directory.path, 'keepOriginalName': keepOriginalName};
      Isolate isolate = await Isolate.spawn(_isolateEntryPoint, param);

      await for (var message in receivePort) {
        if (message is DownloadMessage) {
          AppEventsStream().addEvent(AppEvent(type: AppEventType.downloadProgress, data: message));
          if (message.filePath != null) {
            path = message.filePath ?? '';
            break;
          }
        }
      }
      //path = await receivePort.last;
      isolate.kill(priority: Isolate.immediate);
    } catch (e) {
      LoggerService().log(message: 'Error in download isolate===>${e.toString()}');
    } finally {
      receivePort.close();
    }
    return path;
  }

  Future<void> _isolateEntryPoint(Map<String, dynamic> param) async {
    final SendPort sendPort = param['sendPort'] as SendPort;
    String path = '';
    try {
      final request = http.Request('GET', Uri.parse(param['url']));

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final dir = Directory(param['path']);
        String ext = param['url'].substring(param['url'].lastIndexOf('.') + 1);

        String originalName = param['url'].substring(param['url'].lastIndexOf('/') + 1);
        originalName = originalName.substring(0, originalName.lastIndexOf('.'));

        String newFileName = param['keepOriginalName'] == true ? '$originalName.$ext' : '${DateFormat('yyyy_mm_dd_hh_mm_ss').format(DateTime.now())}.$ext';
        final file = File('${dir.path}/$newFileName');
        final sink = file.openWrite();
        final contentLength = response.contentLength ?? 0;
        int downloaded = 0;
        if (ext.toLowerCase().endsWith('svg')) {
          final response1 = await http.Response.fromStream(response);

          await file.writeAsString(response1.body, flush: true);
        } else {
          await response.stream
              .listen(
                (chunk) {
                  sink.add(chunk);
                  downloaded += chunk.length;
                  if (contentLength > 0) {
                    final progress = (downloaded / contentLength * 100).toStringAsFixed(2);
                    sendPort.send(DownloadMessage(progress: double.tryParse(progress) ?? 0, url: param['url']));
                    LoggerService().log(message: 'Download Progress $progress', level: LogLevel.info);
                  }
                },
                onDone: () async {
                  // await sink.flush();
                  // sink.close();
                  path = file.path;
                  sendPort.send(DownloadMessage(progress: 100, url: param['url'], filePath: file.path));
                },
                onError: (e) {
                  LoggerService().log(message: 'Download error $e', level: LogLevel.info);
                },
                cancelOnError: true,
              )
              .asFuture();
          path = file.path;
          await sink.flush();
          await sink.close();
          sendPort.send(DownloadMessage(progress: 100, url: param['url'], filePath: file.path));
          path = file.path;
        }
      } else {
        LoggerService().log(message: 'error occurred while downloading file ${param['url']} ===>${response.statusCode}');
      }
    } catch (ex) {
      sendPort.send(DownloadMessage(progress: 0, url: param['url']));
      LoggerService().log(message: 'error occurred while downloading file ${ex.toString()}');
    }
    sendPort.send(DownloadMessage(progress: 100, url: param['url'], filePath: path));
    //sendPort.send(path);
  }

  void _uploadFileIsolate(Map<String, dynamic> param) async {
    final sendPort = param['sendPort'] as SendPort;
    try {
      final file = File(param['localPath']);
      FileStat fileStat = await file.stat();
      final totalBytes = fileStat.size;
      int uploadedBytes = 0;
      final uri = Uri.parse(param['url']);
      final ApiMethod method = param['methods'];
      late final http.MultipartRequest request;

      switch (method) {
        case ApiMethod.post:
          request = http.MultipartRequest('POST', uri);
          break;
        case ApiMethod.put:
          request = http.MultipartRequest('PUT', uri);
          break;
        case ApiMethod.get:
          request = http.MultipartRequest('GET', uri);
          break;
        case ApiMethod.delete:
          request = http.MultipartRequest('DELETE', uri);
          break;
      }

      final stream = file.openRead().transform<List<int>>(
        StreamTransformer.fromHandlers(
          handleData: (List<int> chunk, EventSink<List<int>> sink) {
            uploadedBytes += chunk.length;
            final progress = (uploadedBytes / totalBytes) * 100;

            sendPort.send({'status': 'progress', 'progress': progress, 'bytes': uploadedBytes, 'total': totalBytes});
            LoggerService().log(message: 'progress====>$progress');

            sink.add(chunk); // forward chunk
          },
        ),
      );
      LoggerService().log(message: 'preparing upload file request');
      final multipartFile = http.MultipartFile('file', stream, totalBytes, filename: Uri.file(param['localPath']).pathSegments.last);
      request.files.add(multipartFile);
      final response = await request.send();
      LoggerService().log(message: 'file upload response status===>${response.statusCode}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        sendPort.send(100.0);
      } else {
        sendPort.send('invalid http response');
      }
    } catch (e) {
      sendPort.send(e.toString());
    }
  }

  Future<void> uploadFile({required String path, required String url, required ApiMethod method, required Function(double) onProgress, required Function(String) onError}) async {
    try {
      final receivePort = ReceivePort();
      receivePort.listen((message) {
        if (message is double) {
          if (message == 100.0) {
            onProgress(message);
          }
        } else if (message is String) {
          onError(message);
          receivePort.close();
        }
      });
      final param = {'localPath': path, 'sendPort': receivePort.sendPort, 'url': url, 'methods': method};
      LoggerService().log(message: 'calling file upload isolate');
      await Isolate.spawn(_uploadFileIsolate, param);
    } catch (e) {
      //
    }
  }
}
