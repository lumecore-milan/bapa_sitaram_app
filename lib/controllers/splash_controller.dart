import 'package:bapa_sitaram/constants/app_constant.dart';

import 'package:get/get.dart';

import '../constants/api_constant.dart';
import '../models/app_loading.dart';
import '../services/loger_service.dart';

import '../services/network/api_mobile.dart';
import '../services/preference_service.dart';

class SplashController extends GetxController
{

  final _apiInstance=NetworkServiceMobile();
  Rx<AppSettingModel> detail=AppSettingModel().obs;
  Future<(bool,String)> getData()async{
    (bool,String) resp=(false,'');
    try{
      final int userId=PreferenceService().getInt(key: AppConstants().prefKeyUserId);
      await _apiInstance.post(url: APIConstant().apiLoading, requestBody: {
        'user_id':userId==0 ? 'nologin':userId
      }, isFormData: true).then((data){
        if(data['httpStatusCode']==200 && data.isNotEmpty){
                  resp=(true,'');
                  detail.value=AppSettingModel.fromJson(data);
                  detail.refresh();
        }
      });
    }catch(e){
      LoggerService().log(message: e.toString());
    }
    return resp;
  }
}