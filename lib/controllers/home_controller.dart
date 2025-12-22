import 'dart:convert';

import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/models/app_loading.dart';
import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/utils/razor_pay.dart';

import 'package:get/get.dart';
import '../models/home_detail.dart';
import '../services/loger_service.dart';

class HomeDetailController extends GetxController {
  final _apiInstance = NetworkServiceMobile();
  Rx<HomeDetailModel> homeDetail = HomeDetailModel().obs;
  late AppSettingModel appSetting;
  Rx<bool> isLoading = false.obs;
  Map<String, dynamic> aboutUs = {};
  HomeDetailController() {
    getHomeDetail();
  }
  Future<void> getHomeDetail() async {
    try {
      isLoading.value = true;
      await Future.wait([_apiInstance.get(url: APIConstant().apiHomePage), _apiInstance.get(url: APIConstant().apiAboutUs)]).then((responses) {
        isLoading.value = false;
        if (responses[0].isNotEmpty) {
          if (responses[0]['httpStatusCode'] == 200) {
            homeDetail.value = HomeDetailModel.fromJson(responses[0]);

            homeDetail.value.events.sort((a, b) => b.eventDate.compareTo(a.eventDate));
            homeDetail.refresh();
          }
        }
        if (responses[1].isNotEmpty) {
          if (responses[1]['httpStatusCode'] == 200) {
            aboutUs = responses[1];
            RazorPayService().setKey(key: aboutUs['razorpay_key'] ?? '');
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> getEventById({required String eventId}) async {
    try {
      await _apiInstance.post(url: APIConstant().apiEventById, requestBody: {'event_id': eventId}, isFormData: true).then((responses) {
        isLoading.value = false;
        if (responses.isNotEmpty) {
          if (responses['httpStatusCode'] == 200) {
            final temp = EventItem.fromJson(responses['data']);
            homeDetail.value.events.add(temp);
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<List<dynamic>> getMenuDetail({required String menu}) async {
    List<dynamic> data = [];
    try {
      await _apiInstance.post(url: APIConstant().apiMenu, isFormData: false, requestBody: {'main_menu_name': menu}).then((resp) {
        LoggerService().log(message: json.encode(resp));
        if (resp.isNotEmpty) {
          if (resp['httpStatusCode'] == 200) {
            data = resp['data'];
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return data;
  }
}
