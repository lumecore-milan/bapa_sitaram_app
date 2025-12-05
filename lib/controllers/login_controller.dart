import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/api_constant.dart';
import '../constants/app_constant.dart';
import '../services/loger_service.dart';
import '../services/network/api_mobile.dart';
import '../services/preference_service.dart';
import 'package:http/http.dart' as http;
class LoginController extends GetxController {
  final _apiInstance = NetworkServiceMobile();
  Rx<bool> otpSent = false.obs;

  final TextEditingController type = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pinCode = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController panCard = TextEditingController();
  Rx<String> profileImagePath=''.obs;

  Future<(bool, Map<String,String>)> login({required String mobileNo}) async {
    (bool, Map<String,String>) resp = (false, {});
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiLogin,
            requestBody: {'mobile_no': mobileNo},
            isFormData: true,
          )
          .then((data) {
            if (data.isNotEmpty) {
              if (data['httpStatusCode'] == 200) {
                resp = (true, {
                  'userId':'${data['user_id']}',
                  'userStatus':'${data['status']}',
                  'name':'${data['user_name']}',
                  'email':'${data['user_email']}',
                  'mobile':'${data['user_mobile']}',
                  'panCard':'${data['user_panCard']??''}',
                  'address':'${data['user_address']??''}',
                  'pinCode':'${data['user_pincode']??''}',
                  'profileImage':'${data['user_profile_photo']}',
                });
              }else{
                resp =(false, {'error':'Something went wrong'});
              }
            }else{
              resp =(false, {'error':'Something went wrong'});
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return resp;
  }

  Future<(bool, String)> sendOtp({required String mobileNo}) async {
    (bool, String) resp = (false, '');
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiLogin,
            requestBody: {'mobile_no': mobileNo},
            isFormData: false,
          )
          .then((data) {
            if (data.isNotEmpty) {
              otpSent.value = true;
              otpSent.refresh();
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return resp;
  }


  Future<(bool, String)> register() async {
    (bool, String) resp = (false, '');
    try {
      Map<String,dynamic> existingDetail={};
      String temp=PreferenceService().getString(key: AppConstants().prefKeyUserDetail);
      if(temp.isNotEmpty){
        existingDetail=json.decode(temp);

      }



      Map<String, dynamic> body = {
        'mobile_no': existingDetail['mobile'],
        'profile_photo': '',
        'name': name.text,
        'email': email.text,
        'pan_card': panCard.text,
        'address': address.text,
        'pin_code': pinCode.text,
      };

      if (profileImagePath.isNotEmpty) {
        body['profile_photo'] = await http.MultipartFile.fromPath(
          'profile_photo',
          profileImagePath.value,
        );
      }
      await _apiInstance
          .post(
        url: APIConstant().apiUpdateProfile,
        requestBody: body,
        isFormData: true,
      )
          .then((data) {
        if (data.isNotEmpty) {
          if (data['httpStatusCode'] == 200) {
            existingDetail['name'] = name.text;
            existingDetail['email'] = email.text;
            existingDetail['profileImage'] = data['user_profile_photo'] ?? '';

            existingDetail.addAll({
              'panCard': panCard.text,
              'address': address.text,
              'pinCode': pinCode.text,
            });
            PreferenceService().setString(key: AppConstants().prefKeyUserDetail,
                value: json.encode(existingDetail));
            PreferenceService().setBoolean(
                key: AppConstants().prefKeyIsLoggedIn, value: true);
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
