import 'package:bapa_sitaram/constants/api_constant.dart';

import 'package:get/get.dart';
import '../models/punam_model.dart';
import '../services/loger_service.dart';
import '../services/network/api_mobile.dart';

class PunamListController extends GetxController
{
  final _apiInstance=NetworkServiceMobile();
  Rx<PoonamModel> list=PoonamModel().obs;
  Rx<bool> isLoading=false.obs;
  PunamListController(){
    getDetail();
  }
  Future<void> getDetail()async{
    try{
      isLoading.value=true;
      await _apiInstance.get(url: APIConstant().apiPunamList).then((data){
        isLoading.value=false;
        if(data.isNotEmpty){
          if(data['httpStatusCode']==200){
            list.value=PoonamModel.fromJson(data);
            list.refresh();
          }
        }
      });
    }catch(e){
      LoggerService().log(message: e.toString());
    }
  }
}