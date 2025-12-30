import 'dart:convert';
import 'dart:io';

import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/services/app_events.dart';
import 'package:bapa_sitaram/services/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/services/loger_service.dart';

import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:bapa_sitaram/utils/helper.dart';


class DonationController extends GetxController {

  DonationController() {
    final String userDetail = PreferenceService().getString(key: AppConstants().prefKeyUserDetail);
    if (userDetail.isNotEmpty) {
      Map<String, dynamic> detail = json.decode(userDetail);
      if (detail.isNotEmpty) {
        name.text = detail['name'] ?? '';
        email.text = detail['email'] ?? '';
        mobile.text = detail['mobile'] ?? '';
        pinCode.text = detail['pinCode'] ?? '';
        address.text = detail['address'] ?? '';
        panCard.text = detail['panCard'] ?? '';
      }
    }
   /* RazorPayService().onPaymentSuccess.listen((payment) {
      if (payment.paymentId != null) {
        paymentSuccess(paymentId: payment.paymentId ?? '');
      }
    });*/
  }
  Rx<bool> isPrivacyAccepted = false.obs;
  final TextEditingController type = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pinCode = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController panCard = TextEditingController();
  final _apiInstance = NetworkServiceMobile();
  void clearForm() {
    type.clear();
    name.clear();
    mobile.clear();
    amount.clear();
    email.clear();
    pinCode.clear();
    address.clear();
    panCard.clear();
  }

  Rx<bool> otpSent = false.obs;

  Future<(bool, String)> submit() async {
    (bool, String) resp = (false, '');
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiCreateOrder,
            requestBody: {
              'user_id': Platform.isIOS ? 1 : PreferenceService().getInt(key: AppConstants().prefKeyUserId),
              'amount': int.parse(amount.text) * 100,
            },
            isFormData: true,
          )
          .then((data) async {
            LoggerService().log(message: data);
            if (data.isNotEmpty) {
              if (data['httpStatusCode'] == 200) {
               // await RazorPayService().makePayment(data: {'amount': data['amount'], 'name': name.text.trim(), 'description': 'Sample payment', 'orderId': data['order_id'], 'contact': '+91${mobile.text}', 'email': email.text});
              }
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return resp;
  }

  Future<(bool, String)> paymentSuccess({required String paymentId}) async {
    (bool, String) resp = (false, '');
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiPaymentSuccess,
            requestBody: {'payment_id': paymentId, 'name': name.text, 'email': email.text, 'mobile_no': mobile.text, 'pan_no': panCard.text, 'donation_type': type.text, 'address': address.text, 'pin_code': pinCode.text},
            isFormData: false,
          )
          .then((data) {
            if (data.isNotEmpty) {
              if (data['httpStatusCode'] == 200) {
                clearForm();
                AppEventsStream().addEvent(AppEvent(type: AppEventType.paymentSuccess, data: data));
                Helper.showMessage(title: 'Success', message: 'Payment successful', isSuccess: true);
              }
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return resp;
  }
}
