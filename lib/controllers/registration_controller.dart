import 'dart:convert';

import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  RegistrationController() {
    String temp = PreferenceService().getString(key: AppConstants().prefKeyUserDetail);
    if (temp.isNotEmpty) {
      existingDetail = json.decode(temp);
      mobile.text = existingDetail['mobile'] ?? '';
      name.text = existingDetail['name'] ?? '';
      profileImagePath.value = existingDetail['profileImage'] ?? '';
      email.text = existingDetail['email'] ?? '';
      panCard.text = existingDetail['panCard'] ?? '';
      pinCode.text = existingDetail['pinCode'] ?? '';
      address.text = existingDetail['address'] ?? '';
    }
  }

  Map<String, dynamic> existingDetail = {};
  final _apiInstance = NetworkServiceMobile();
  final TextEditingController type = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pinCode = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController panCard = TextEditingController();
  Rx<String> profileImagePath = ''.obs;
  Future<(bool, String)> register() async {
    (bool, String) resp = (false, '');
    try {
      Map<String, dynamic> body = {'mobile_no': existingDetail['mobile'], 'profile_photo': '', 'name': name.text, 'email': email.text, 'pan_card': panCard.text, 'address': address.text, 'pin_code': pinCode.text};

      if (profileImagePath.isNotEmpty && profileImagePath.startsWith('http') == false) {
        body['profile_photo'] = await http.MultipartFile.fromPath('profile_photo', profileImagePath.value);
      }
      await _apiInstance.post(url: APIConstant().apiUpdateProfile, requestBody: body, isFormData: true).then((data) {
        if (data.isNotEmpty) {
          if (data['httpStatusCode'] == 200) {
            existingDetail['name'] = name.text;
            existingDetail['email'] = email.text;
            existingDetail['profileImage'] = data['user_profile_photo'] ?? '';

            existingDetail.addAll({'panCard': panCard.text, 'address': address.text, 'pinCode': pinCode.text});
            PreferenceService().setString(key: AppConstants().prefKeyUserDetail, value: json.encode(existingDetail));
            resp = (true, 'Profile detail updated');
          } else {
            resp = (false, 'Something went wrong');
          }
        } else {
          resp = (false, 'Something went wrong');
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return resp;
  }
}
