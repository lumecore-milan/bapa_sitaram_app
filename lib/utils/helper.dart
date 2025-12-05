import 'dart:math';
import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constant.dart';
import '../services/helper_service.dart';
import '../services/loger_service.dart';
import '../widget/custom_loader.dart';


class Helper {
  static String generateRandomId({int length = 8}) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(
      length,
          (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  static Future<void> launch({required String url})async{
    try{
      if(Uri.tryParse(url)!=null && Uri.tryParse(url)!.scheme.isNotEmpty) {
        if (!await launchUrl(Uri.parse(url))) {
          throw Exception('Could not launch $url');
        }
      }else{
        LoggerService().log(message: 'Error while launching url ${e.toString()}');
      }
    }catch(e){
     LoggerService().log(message: 'Error while launching url ${e.toString()}');
    }
  }
  static void showLoader() async {
    try {
      await showDialog(
        context: AppConstants().navigatorKey.currentContext!,
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
        barrierColor: Colors.transparent.withOpacity(0.3),
        builder: (context) {
          return const CustomLoader();
        },
      );
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  static void closeLoader() {
    try {
      if (Navigator.canPop(AppConstants().navigatorKey.currentContext!)) {
        Navigator.pop(AppConstants().navigatorKey.currentContext!);
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }


  static String getFileType({required String path}){

      String ext=path.substring(path.lastIndexOf('.')+1);
      if(['mp4','.mkv','wmv','avi','mpeg'].indexOf(ext)>=0){
        return 'VIDEO';
      }else if(['jpg','jpeg','png','ico','svg','hevc','heic'].lastIndexOf(ext)>=0){
        return 'IMAGE';
      }else if(['.mp3','wav','aiff'].indexOf(ext)>=0){
        return 'AUDIO';
      }else if(['.pdf','doc','docx','.ppt','.txt'].indexOf(ext)>=0){
        return 'DOC';
      }else{
        return 'OTHER';
      }
  }




  static Future<void> noInternetDialog() async {
    try {
      await showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        useRootNavigator: true,
        context: AppConstants().scaffoldMessengerKey.currentContext!,
        builder: (_) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.all(20),
            titlePadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: Text('No Internet')),
                  GestureDetector(
                    onTap: () => Navigator.pop(
                      AppConstants().scaffoldMessengerKey.currentContext!,
                    ),
                    child: const Icon(Icons.close, size: 24, color: Colors.red),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular((5).toDouble()),
            ),
          );
        },
      );
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  static void hideDialog() {
    try {
      if (!AppConstants().isDialogOpen) {
        AppConstants().isDialogOpen = false;
        Navigator.pop(AppConstants().navigatorKey.currentContext!);
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }
  static void showMessage({
    required String title,
    required String message,
    required bool isSuccess,
    int durationInSecond = 2,
    bool showIcon = true,
  }) {
      HelperService().hideKeyboard(
        context: AppConstants().scaffoldMessengerKey.currentState!.context,
      );
      SnackBarBehavior behaviour = SnackBarBehavior.floating;
      AppConstants().scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          elevation: 5,
          behavior: behaviour,
          margin: .only(bottom:60,left:20,right:20),
          backgroundColor: CustomColors().white,
          padding: .all(10),
          duration: Duration(
            seconds: durationInSecond),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  maxLines: 2,
                  style: isSuccess
                      ? semiBold(
                    fontSize:
                      12,
                    color: CustomColors().green500,
                  )
                      : semiBold(
                    fontSize: 12,
                    color: CustomColors().red500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

class PanCardInputFormatter1 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text.toUpperCase();

    // Remove everything except A–Z, 0–9
    text = text.replaceAll(RegExp(r'[^A-Z0-9]'), "");

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 10; i++) {
      String char = text[i];

      if (i < 5) {
        // First 5 → only letters
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      } else if (i < 9) {
        // 6th–9th → only digits
        if (RegExp(r'[0-9]').hasMatch(char)) buffer.write(char);
      } else if (i == 9) {
        // 10th → only letter
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}



final formatterAadhaarLength = LengthLimitingTextInputFormatter(12);
final formatterPanCardLength = LengthLimitingTextInputFormatter(10);
final formatterPostalCodeLength = LengthLimitingTextInputFormatter(6);
final formatterIFSCCodeLength = LengthLimitingTextInputFormatter(11);

final formatterReimbursementMaximumAmount = LengthLimitingTextInputFormatter(6);
final formatterDigitsOnly = FilteringTextInputFormatter.digitsOnly;
final formatterAmount =
FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));
final formatterDenySpace = FilteringTextInputFormatter.deny(RegExp(r'\s'));
final formatterAllowSpace = FilteringTextInputFormatter.allow(RegExp(r'\s'));
final formatterAllowOnlyAlphanumeric =
FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]'));
final formatterAllowOnlyAlphanumericWithAtSymbol =
FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z@]'));
final formatterEmail = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-+]'));
final formatterAllowOnlyAlphabets =
FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'));
final formatterAllowOnlyAlphabetsWithSpace =
FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z][a-zA-Z\s]*$'));
final formatterAllowAlphabetsAndOtherCharacters =
FilteringTextInputFormatter.allow(RegExp(r'[.,\-_:;A-Za-z\s]+'));
final formatterAllowOnlyAlphaNumericWithSpace =
FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-zA-Z\s]*$'));

final formatterAllowOnlyAlphaNumericWithSpaceAndDot =
FilteringTextInputFormatter.allow(RegExp(r'^[.0-9a-zA-Z\s]*$'));
