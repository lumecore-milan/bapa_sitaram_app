import 'dart:io';
import 'dart:math' show Random;

import 'package:bapa_sitaram/utils/helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bapa_sitaram/services/download/download_helper_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show BuildContext, FocusManager, FocusScope, FocusNode;
import 'package:flutter/services.dart' show MethodChannel, SystemChannels;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'enums.dart';
import 'loger_service.dart';

class HelperService {
  factory HelperService() => _instance;

  HelperService._internal();

  static final HelperService _instance = HelperService._internal();

  Future<void> openAppStore() async {
    final Uri androidUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.bapasitaram.bagdana');
    final Uri iosUrl = Uri.parse('https://apps.apple.com/in/app/bapasitaram-temple-official/id6756720753');
    final Uri url = Platform.isIOS ? iosUrl : androidUrl;
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      return;
    }
  }

  final _methodChannel = 'flutter.myapp.app/myChannel';
  static final Map<String, AudioPlayer> _players = {};

  Future initSoundSources({required List<String> soundFiles}) async {
    for (var file in soundFiles) {
      final player = AudioPlayer();
      await player.setAudioSource(AudioSource.asset(file));
      _players[file] = player;
    }
  }

  Future<void> playSound({required String sound, bool stop = false}) async {
    try {
      final player = _players[sound];
      if (player == null) return;
      if (player.playing) {
        player.stop();
      }
      player.seek(Duration.zero); // restart
      player.play();
    } catch (e) {}
  }

  Future<String?> pickFile({int defaultFileSizeINKB = 4096, String dialogTitle = 'Select file', required AllowedFileType fileType}) async {
    try {
      List<String> allowedFileType = ['jpg', 'jpeg', 'png', 'pdf', 'heic'];
      if (fileType == AllowedFileType.image) {
        allowedFileType = ['jpg', 'jpeg', 'png', 'heic'];
      } else if (fileType == AllowedFileType.pdf) {
        allowedFileType = ['pdf', 'docx', 'doc'];
      }

      final FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(allowMultiple: false, dialogTitle: dialogTitle, type: FileType.custom, allowedExtensions: allowedFileType);
      if (selectedFile != null) {
        late File file;
        String extension = selectedFile.files.first.path ?? '';
        extension = extension.substring(extension.lastIndexOf('.') + 1);
        if (extension.toUpperCase() == 'HEIC' || extension.toUpperCase() == 'HEIF' || extension.toUpperCase() == 'HEICS') {
          file = File(selectedFile.files.first.path!);
          /*String newPath = selectedFile.files.first.path!.replaceAll(
              RegExp(r'.heic|.heif|.heics', caseSensitive: false), '.jpg');
          XFile? path = await FlutterImageCompress.compressAndGetFile(
              selectedFile.files.first.path!, newPath);
          if (path != null) {
            file = File(path.path);
          }*/
        } else {
          file = File(selectedFile.files.first.path!);
        }
        int sizeInBytes = await file.length();
        int sizeInKB = (sizeInBytes / 1024).round();

        if (sizeInKB > defaultFileSizeINKB) {
          Helper.showMessage(title: 'Error', message: 'Please select file up to $defaultFileSizeINKB KB', isSuccess: false);
          return null;
        } else {
          return file.path;
        }
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return null;
  }

  Future<String> getDownloadDirectory() async {
    MethodChannel channel = MethodChannel(_methodChannel);
    try {
      if (Platform.isAndroid) {
        //path_provider library is not supported in android version so we have to use native functionality.
        String path = await channel.invokeMethod('getDownloadDirectory');
        return path;
      } else if (Platform.isIOS) {
        final Directory downloadsDir = await getApplicationDocumentsDirectory();
        return downloadsDir.path;
      }
    } catch (ex) {
      LoggerService().log(message: 'Error while getting download directory===>$ex');
    }
    return '';
  }

  Future<String> getApplicationDirectory() async {
    try {
      final Directory downloadsDir = await getApplicationDocumentsDirectory();
      return downloadsDir.path;
    } catch (ex) {
      LoggerService().log(message: 'Error while getting download directory===>$ex');
    }
    return '';
  }

  int generateRandomNumber() {
    Random rng = Random();
    return rng.nextInt(10000000);
  }

  String convertStringToInitCap({required String word}) {
    if (word.isEmpty) {
      return '';
    }
    return word[0].toUpperCase() + word.substring(1);
  }

  Future<bool> showBatteryOptimizationDialog({required bool isSystemDialog}) async {
    bool status = true;
    try {
      if (Platform.isAndroid) {
        if (isSystemDialog) {
          status = await MethodChannel(_methodChannel).invokeMethod('checkOptimizationStatus');
          if (!status) {
            MethodChannel(_methodChannel).invokeMethod('openBatteryOptimizationSetting');
          }
        }
      }
    } catch (e) {
      LoggerService().log(message: e);
    }
    return status;
  }

  String? getFormattedDate({required String date, String outputFormat = 'dd-MM-yyyy'}) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      if (parsedDate.isUtc) {
        parsedDate = parsedDate.toLocal();
      }
      return DateFormat(outputFormat).format(parsedDate);
    } catch (e) {
      LoggerService().log(message: 'Invalid date format exception==>$e');
      return null;
    }
  }

  DateTime parseDate({required String date, String inputFormat = 'dd-MM-yyyy'}) {
    try {
      return DateFormat(inputFormat).parse(date);
    } catch (e) {
      LoggerService().log(message: 'Invalid date format exception==>$e');
    }
    return DateTime.now();
  }

  bool isUrl(String string) {
    final urlPattern = RegExp(r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9]+([-.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$');
    return urlPattern.hasMatch(string);
  }

  Future<String?> downloadFile({required String url}) async {
    if (isUrl(url)) {
      try {
        String? path = await DownloadServiceMobile().download(url: url);
        return path;
      } catch (e) {
        LoggerService().log(message: e);
        return null;
      }
    }
    return null;
  }

  Future<bool> checkDeviceSecurity() async {
    bool status = true;
    MethodChannel channel = MethodChannel(_methodChannel);
    try {
      if (Platform.isAndroid) {
        status = await channel.invokeMethod('checkDeviceSecure');
      } else {
        status = false;
      }
    } catch (ex) {
      LoggerService().log(message: ex);
      status = false;
    }
    return status;
  }

  Future<bool> checkMockLocationStatus() async {
    bool status = false;
    MethodChannel channel = MethodChannel(_methodChannel);
    try {
      if (kIsWeb) {
        status = false;
      } else if (Platform.isAndroid) {
        status = await channel.invokeMethod('checkMockLocationStatus');
      } else {
        status = false;
      }
    } catch (ex) {
      LoggerService().log(message: ex);
      status = false;
    }
    return status;
  }

  void hideKeyboard({required BuildContext context}) {
    FocusManager.instance.primaryFocus!.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
