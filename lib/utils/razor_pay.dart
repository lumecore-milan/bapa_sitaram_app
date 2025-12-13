import 'dart:async';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../services/loger_service.dart';

class RazorPayService{
  final StreamController<PaymentSuccessResponse> _paymentSuccessController =StreamController<PaymentSuccessResponse>.broadcast();
  Stream<PaymentSuccessResponse> get onPaymentSuccess =>_paymentSuccessController.stream;
  factory RazorPayService() => _instance;
  RazorPayService._internal(){
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  static final RazorPayService _instance = RazorPayService._internal();

  final _razorpay = Razorpay();
  late final String _key;
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('razor payment successful');
    _paymentSuccessController.add(response);
      print(response.data??{});
      print(response.orderId);
      print(response.signature);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('razor payment error');
    print(response.code??{});
    print(response.error);
    print(response.message);
  }
void setKey({required String key}){
  _key=key;
}
  void _handleExternalWallet(ExternalWalletResponse response) {
    print('razor payment handle external wallet');
    print(response.walletName??{});
  }

  Future<void> makePayment({required Map<String,dynamic> data})async{
    try{
      var options = {
        'key': _key,
        "order_id": data['orderId'],
        "currency": "INR",
        'amount': data['amount'],
        'name': data['name'],
        'description': data['description'],
        'prefill': {
          'contact': data['contact'],
          'email': data['email']
        }
      };

      _razorpay.open(options);
    }catch(e){
      LoggerService().log(message: e.toString());
    }
  }
}