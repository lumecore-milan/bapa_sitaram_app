import 'package:bapa_sitaram/constants/app_constant.dart';

import 'package:get/get.dart';

import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/models/app_loading.dart';
import 'package:bapa_sitaram/services/loger_service.dart';

import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/services/preference_service.dart';

class SplashController extends GetxController {
  final _apiInstance = NetworkServiceMobile();
  Rx<AppSettingModel> detail = AppSettingModel().obs;
  Future<(bool, String)> getData() async {
    (bool, String) resp = (false, '');
    try {
      final int userId = PreferenceService().getInt(key: AppConstants().prefKeyUserId);
      await _apiInstance.post(url: APIConstant().apiLoading, requestBody: {'user_id': userId == 0 ? 'nologin' : userId}, isFormData: true).then((data) {
        if (data['httpStatusCode'] == 200 && data.isNotEmpty) {
          resp = (true, '');
          detail.value = AppSettingModel.fromJson(data);
          AppConstants.detail=detail.value;

          if(detail.value.userInfo.userStatus=='deleted');
          {
            PreferenceService().clear();
          }
          detail.refresh();
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return resp;
  }
}
