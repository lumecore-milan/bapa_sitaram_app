import 'dart:convert';

import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bapa_sitaram/extensions/size_box_extension.dart';

import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:bapa_sitaram/utils/helper.dart';
import 'package:bapa_sitaram/widget/custom_button.dart';
import 'package:bapa_sitaram/widget/custom_text_field.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key, this.showAppBar = false});
  final bool showAppBar;
  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    final d=PreferenceService().getString(key: AppConstants().prefKeyUserDetail);
    if(d.isNotEmpty){
      final jsonData=json.decode(d);
      _mobileController.text=jsonData['mobile']??'';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.showAppBar);
    return Scaffold(
      appBar: widget.showAppBar == false
          ? null
          : CustomAppbar(
        title: 'Delete Account',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    10.h,
                    Text('Note: Once you delete your account, it cannot be recovered. All your data will be permanently removed.', style: bolder(fontSize: 12, color: CustomColors().grey500)),
                    20.h,
                    Form(
                      key: _formKey,
                      child: CustomTextFormField(
                        validator: (val) {
                          if ((val ?? '').trim().length < 10) {
                            return '10 આકડાનો મોબાઇલ નંબર દાખલ કરો';
                          }
                          return null;
                        },
                        isMobile: true,
                        showMainTitle: false,
                        formatter: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                        inputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                        controller: _mobileController,
                        label: 'મોબાઇલ',
                        readOnly: true,
                        hint: 'મોબાઇલ નંબર દાખલ કરો',
                        errorMessage: '10 આકડાનો મોબાઇલ નંબર દાખલ કરો',
                      ),
                    ),
                    20.h,

                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CommonButton(
                    onTap: () async {

                      if (_formKey.currentState!.validate() && _mobileController.text.length >= 10) {
                        HelperService().hideKeyboard(context: context);
                        await NetworkServiceMobile().post(url: APIConstant().apiDeleteAccount, requestBody: {'mobile_no': _mobileController.text}, isFormData: true).then((data) {
                          if (data.isNotEmpty) {
                            if (data['httpStatusCode'] == 200) {

                              PreferenceService().clear();
                              navigate(context: context, replace: true, path: loginRoute,removePreviousRoute: true);
                              Helper.showMessage(title: 'Success', message: 'Account is successfully deleted.', isSuccess: true);
                            } else {
                              navigate(context: context, replace: true, path: loginRoute,removePreviousRoute: true);
                              Helper.showMessage(title: 'Success', message: 'Something went wrong, please try again later.', isSuccess: false);
                            }
                          } else {
                            navigate(context: context, replace: true, path: loginRoute,removePreviousRoute: true);
                            Helper.showMessage(title: 'Error', message: 'Something went wrong', isSuccess: false);
                          }
                        });
                      }
                    },
                    title: 'Delete Account',
                  ),
                ),)
          ],
        ),
      ),
    );
  }
}
