import 'dart:async';

import 'package:bapa_sitaram/utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class OTPDetail {
  OTPDetail({required this.success, required this.error, required this.otp, required this.sent});
  final bool success, sent;
  final String error, otp;
}

class FirebaseOtpHelper {
  factory FirebaseOtpHelper() => _instance;
  FirebaseOtpHelper._internal();
  static final FirebaseOtpHelper _instance = FirebaseOtpHelper._internal();
  final StreamController<OTPDetail> otpController = StreamController<OTPDetail>.broadcast();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  Future<bool> sendOTP({required String mobile}) async {
    bool isCodeSent = false;
    verificationId = '';
    try {
      // await _auth.setSettings(appVerificationDisabledForTesting: true);
      //  String temp = Platform.isAndroid ? mobile : '${mobile.substring(0, 3)} ${mobile.substring(3, 8)} ${mobile.substring(8, 12)}';
      //  print(temp);
      await _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('✅ SILENT PUSH VERIFICATION SUCCEEDED');
          otpController.sink.add(OTPDetail(sent: true, success: true, error: '', otp: credential.smsCode ?? ''));
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Helper.showMessage(title: 'Error', message: e.toString(), isSuccess: false);
          otpController.sink.add(OTPDetail(sent: true, success: false, error: e.message ?? '', otp: ''));
        },
        codeSent: (String verificationIdParam, int? resendToken) {
          isCodeSent = true;
          verificationId = verificationIdParam;

          otpController.sink.add(OTPDetail(sent: true, success: false, error: '', otp: ''));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          otpController.sink.add(OTPDetail(sent: true, success: false, error: verificationId, otp: ''));
        },
      );
    } catch (e) {
      print('error while send otp $e');
    }
    return isCodeSent;
  }

  Future<(bool, Map<String, dynamic>)> verifyOTP({required String otp}) async {
    (bool, Map<String, dynamic>) status = (false, {});
    try {
      final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      final result = await _auth.signInWithCredential(credential);
      if (result.user != null) {
        status = (true, {'name': result.user!.displayName ?? '', 'mobile': result.user!.phoneNumber ?? '', 'email': result.user!.email ?? '', 'profileImage': result.user!.photoURL ?? '', 'userId': result.user!.uid});
      }
    } catch (e) {
      print('error  while verify otp $e');
    }
    return status;
  }
}
