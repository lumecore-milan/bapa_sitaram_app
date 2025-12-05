import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../constants/api_constant.dart';
import '../services/loger_service.dart';

import '../services/network/api_mobile.dart';
import '../services/preference_service.dart';
import '../utils/helper.dart';
import '../utils/razor_pay.dart';

class DonationController extends GetxController {
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

  DonationController() {
    RazorPayService().onPaymentSuccess.listen((payment) {
      if(payment.paymentId!=null) {
        paymentSuccess(paymentId: payment.paymentId??'');

      }
    });
  }

  Rx<bool> otpSent = false.obs;

  Future<(bool, String)> submit() async {

    (bool, String) resp = (false, '');
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiCreateOrder,
            requestBody: {
              'user_id': PreferenceService().getInt(
                key: AppConstants().prefKeyUserId,
              ),
              'amount': double.parse(amount.text) * 100,
            },
            isFormData: false,
          )
          .then((data) {
            if (data.isNotEmpty) {
              if (data['httpStatusCode'] == 200) {
                RazorPayService().makePayment(
                  data: {
                    'amount': data['amount'],
                    'name': name.text.trim(),
                    'description': 'Sample payment',
                    'orderId': data['order_id'],
                    'contact': '+91${mobile.text}',
                    'email': email.text,
                  },
                );
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
            requestBody: {
              'payment_id': paymentId,
              'name': name.text,
              'email': email.text,
              'mobile_no': mobile.text,
              'pan_no': panCard.text,
              'donation_type': type.text,
              'address': address.text,
              'pin_code': pinCode.text,
            },
            isFormData: false,
          )
          .then((data) {
            if (data.isNotEmpty) {
              if (data['httpStatusCode'] == 200) {
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
