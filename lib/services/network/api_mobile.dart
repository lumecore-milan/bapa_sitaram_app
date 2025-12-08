import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../connectivity_service.dart';
import '../enums.dart';
import '../loger_service.dart';

class NetworkServiceMobile {
  factory NetworkServiceMobile() => _instance;

  NetworkServiceMobile._internal();

  static final NetworkServiceMobile _instance =
      NetworkServiceMobile._internal();

  int timeOut = 60;

  Map<String, String> _getHeader({bool isFormData = false}) {
    return isFormData == false
        ? {'Content-Type': 'application/json'}
        : {'Content-Type': 'multipart/form-data'};
  }

  Future<Map<String, dynamic>> delete({
    required String url,
    required Map<String, dynamic> requestBody,
    bool isFormData = false,
  }) async {
    Map<String, dynamic> apiResponse = {};
    try {
      if (ConnectivityService().hasInternet == false) {
        apiResponse.addAll({
          'httpStatusCode': -2,
          'error': 'No Internet connection',
        });
      } else {
        bool hasFile = requestBody.values.any(
          (v) => v is http.MultipartFile || v is File,
        );
        late final http.Response response;
        if (hasFile || isFormData) {
          var request = http.MultipartRequest('DELETE', Uri.parse(url));
          for (var entry in requestBody.entries) {
            var key = entry.key;
            var value = entry.value;

            if (value is http.MultipartFile) {
              request.files.add(value);
            } else if (value is File) {
              request.files.add(
                await http.MultipartFile.fromPath(key, value.path),
              );
            } else {
              request.fields[key] = '$value';
            }
          }
          final reqClient = http.Client();

          await reqClient.send(request).then((resp) async {
            response = await http.Response.fromStream(resp);
          });
        } else {
          response = await http
              .delete(
                Uri.parse(url),
                headers: _getHeader(isFormData: hasFile || isFormData),
                body: json.encode(requestBody),
              )
              .timeout(
                Duration(seconds: timeOut),
                onTimeout: () {
                  return http.Response(
                    json.encode({'error': 'Request timed out'}),
                    408,
                  );
                },
              );
        }
        if (response.statusCode != 200) {
          LoggerService().log(
            message: 'API status code warning',
            level: LogLevel.warning,
          );
        }
        apiResponse = json.decode(response.body);
        apiResponse.addAll({'httpStatusCode': response.statusCode});
      }
    } catch (e) {
      apiResponse.addAll({'httpStatusCode': -1, 'error': e.toString()});
      LoggerService().log(message: e, level: LogLevel.error);
    }
    return apiResponse;
  }

  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, String> headers = const {},
  }) async {
    Map<String, dynamic> apiResponse = {};
    try {
      if (ConnectivityService().hasInternet == false) {
        apiResponse.addAll({
          'httpStatusCode': -2,
          'error': 'No Internet connection',
        });
      } else {
        final reqClient = http.Client();
        final response = await reqClient
            .get(Uri.parse(url), headers: headers)
            .timeout(
              Duration(seconds: timeOut),
              onTimeout: () {
                return http.Response(
                  json.encode({'error': 'Request timed out'}),
                  408,
                );
              },
            );
        if (response.statusCode != 200) {
          LoggerService().log(
            message: 'API status code warning',
            level: LogLevel.warning,
          );
        }
        final temp = json.decode(response.body);

        if (temp is List) {
          apiResponse['data'] = json.decode(response.body);
        } else {
          apiResponse = json.decode(response.body);
        }

        apiResponse.addAll({'httpStatusCode': response.statusCode});
      }
    } catch (e) {
      apiResponse.addAll({'httpStatusCode': -1, 'error': e.toString()});
      LoggerService().log(message: e, level: LogLevel.error);
    }
    return apiResponse;
  }

  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> requestBody,
    bool isFormData = false,
  }) async {
    Map<String, dynamic> apiResponse = {};
    try {
      if (ConnectivityService().hasInternet == false) {
        apiResponse.addAll({
          'httpStatusCode': -2,
          'error': 'No Internet connection',
        });
      } else {
        bool hasFile = requestBody.values.any(
          (v) => v is http.MultipartFile || v is File,
        );

        late final http.Response response;
        if (hasFile || isFormData) {
          final reqClient = http.Client();
          var request = http.MultipartRequest('POST', Uri.parse(url));
          bool fileFound = false;
          for (var entry in requestBody.entries) {
            var key = entry.key;
            var value = entry.value;

            if (value is http.MultipartFile) {
              fileFound = true;
              request.files.add(value);
            } else if (value is File) {
              fileFound = true;
              request.files.add(
                await http.MultipartFile.fromPath(key, value.path),
              );
            } else {
              request.fields[key] = '$value';
            }
          }
          print(request.fields);
         request.headers.addAll(_getHeader(isFormData: true));
          final streamResponse= await reqClient.send(request);
          response=await http.Response.fromStream(streamResponse);
        } else {
          final reqClient = http.Client();
          response = await reqClient
              .post(
                Uri.parse(url),
                headers: _getHeader(isFormData: hasFile || isFormData),
                body: json.encode(requestBody),
              )
              .timeout(
                Duration(seconds: timeOut),
                onTimeout: () {
                  return http.Response(
                    json.encode({'error': 'Request timed out'}),
                    408,
                  );
                },
              );
        }

        if (response.statusCode != 200) {
          LoggerService().log(
            message: 'API status code warning  ${response.statusCode}====> ${response.body}',
            level: LogLevel.warning,
          );
        }
        final temp = json.decode(response.body);

        if (temp is List) {
          apiResponse['data'] = json.decode(response.body);
        } else {
          apiResponse = json.decode(response.body);
        }

        apiResponse.addAll({'httpStatusCode': response.statusCode});
      }
    } catch (e) {
      apiResponse.addAll({'httpStatusCode': -1, 'error': e.toString()});
      LoggerService().log(message: e, level: LogLevel.error);
    }
    return apiResponse;
  }

  Future<Map<String, dynamic>> put({
    required String url,
    required Map<String, dynamic> requestBody,
    bool isFormData = false,
  }) async {
    Map<String, dynamic> apiResponse = {};
    try {
      if (ConnectivityService().hasInternet == false) {
        apiResponse.addAll({
          'httpStatusCode': -2,
          'error': 'No Internet connection',
        });
      } else {
        bool hasFile = requestBody.values.any(
          (v) => v is http.MultipartFile || v is File,
        );

        late final http.Response response;
        if (hasFile || isFormData) {
          var request = http.MultipartRequest('PUT', Uri.parse(url));
          for (var entry in requestBody.entries) {
            var key = entry.key;
            var value = entry.value;

            if (value is http.MultipartFile) {
              request.files.add(value);
            } else if (value is File) {
              request.files.add(
                await http.MultipartFile.fromPath(key, value.path),
              );
            } else {
              request.fields[key] = '$value';
            }
          }
          final reqClient = http.Client();
          await reqClient.send(request).then((resp) async {
            response = await http.Response.fromStream(resp);
          });
        } else {
          final reqClient = http.Client();
          response = await reqClient
              .put(
                Uri.parse(url),
                headers: _getHeader(isFormData: hasFile || isFormData),
                body: json.encode(requestBody),
              )
              .timeout(
                Duration(seconds: timeOut),
                onTimeout: () {
                  return http.Response(
                    json.encode({'error': 'Request timed out'}),
                    408,
                  );
                },
              );
        }
        if (response.statusCode != 200) {
          LoggerService().log(
            message: 'API status code warning',
            level: LogLevel.warning,
          );
        }
        apiResponse = json.decode(response.body);
        apiResponse.addAll({'httpStatusCode': response.statusCode});
      }
    } catch (e) {
      apiResponse.addAll({'httpStatusCode': -1, 'error': e.toString()});
      LoggerService().log(message: e, level: LogLevel.error);
    }
    return apiResponse;
  }

  void setTimeOut({required int durationInSeconds}) {
    timeOut = durationInSeconds;
  }
}
