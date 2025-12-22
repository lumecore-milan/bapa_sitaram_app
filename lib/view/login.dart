import 'dart:convert';
import 'dart:io';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/controllers/login_controller.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/helper.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../constants/app_constant.dart';
import '../constants/routes.dart';
import '../extensions/size_box_extension.dart';
import '../models/app_loading.dart';
import '../services/preference_service.dart';
import '../utils/firebase_otp.dart';
import '../utils/size_config.dart';
import '../widget/custom_button.dart';
import '../widget/image_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.detail});

  final AppSettingModel detail;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    Get.delete<LoginController>();
    super.dispose();
  }

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Rx<bool> isPrivacyAccepted = false.obs;
  Rx<bool> isUserRegistered = false.obs;
  final LoginController _controller = Get.put(LoginController());

  @override
  void initState() {
    FirebaseOtpHelper().otpController.stream.listen((d) {
      if (d.sent == true) {
        _controller.otpSent.value = true;
        _controller.otpSent.refresh();
        if (d.otp.isNotEmpty) {
          _mobileController.text = d.otp;
        }
      }
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isUserRegistered.value = PreferenceService().getBoolean(key: AppConstants().prefKeyIsRegistered);
      if (isUserRegistered.value == true) {
        _mobileController.text = PreferenceService().getString(key: AppConstants().prefKeyMobile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mobile(context: context);
  }

  Widget _mobile({required BuildContext context}) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig().height,
            width: SizeConfig().width,
            child: Column(
              children: [
                SizedBox(
                  height: 270,
                  child: Stack(
                    clipBehavior: Clip.none, // allow overflow
                    children: [
                      // Top Image Container
                      Container(
                        height: 250,
                        width: SizeConfig().width,
                        decoration: BoxDecoration(
                          color: CustomColors().white,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                          child: Image.asset('assets/images/bg_image.jpeg', fit: BoxFit.cover, color: CustomColors().primaryColorDark.withOpacity(0.7), colorBlendMode: BlendMode.multiply),
                        ),
                      ),
                      Positioned(
                        top: 250 - 40, // half outside
                        left: (SizeConfig().width / 2) - 40,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                          child: ImageWidget(url: 'assets/images/asram_logo.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: CustomColors().layoutPrimaryBackground),
                    child: Padding(
                      padding: .only(top: 50, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: CustomColors().yellow600,
                            padding: .symmetric(horizontal: 5),
                            child: Text('Login Your Account', style: bolder(fontSize: 16)),
                          ),
                          16.h,
                          Text('બાપા સીતારામ', style: bolder(fontSize: 20)),
                          10.h,
                          Obx(
                            () => isUserRegistered.value == true
                                ? registrationForm()
                                : Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text('Enter Your Mobile Number to Login', style: semiBold(fontSize: 14)),
                                      10.h,
                                      Form(
                                        key: _formKey,
                                        child: CustomTextFormField(
                                          validator: (val) {
                                            if ((val ?? '').trim().length != 10) {
                                              return 'ફક્ત 10 આકડાનો મોબાઇલ નંબર દાખલ કરો';
                                            }
                                            return null;
                                          },
                                          isMobile: true,
                                          showMainTitle: false,
                                          formatter: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                                          inputType: TextInputType.numberWithOptions(decimal: false, signed: true),
                                          controller: _mobileController,
                                          label: 'મોબાઇલ',
                                          hint: 'મોબાઇલ નંબર દાખલ કરો',
                                          errorMessage: 'ફક્ત 10 આકડાનો મોબાઇલ નંબર દાખલ કરો',
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              isPrivacyAccepted.toggle();
                                              if (isPrivacyAccepted.value == true) {
                                                navigate(context: context, replace: false, path: policyRoute, param: {'title': 'Privacy Policy', 'data': widget.detail.aboutUs.privacyPolicy});
                                              }
                                            },
                                            child: Obx(
                                              () => Container(
                                                alignment: .center,
                                                decoration: BoxDecoration(
                                                  color: isPrivacyAccepted.value == true ? CustomColors().primaryColorDark : null,
                                                  borderRadius: BorderRadius.circular(0),
                                                  border: .all(color: CustomColors().grey600, width: 1),
                                                ),
                                                height: 18,
                                                width: 18,

                                                child: isPrivacyAccepted.value == true ? Icon(Icons.check, color: CustomColors().white, size: 12) : SizedBox.shrink(),
                                              ),
                                            ),
                                          ),
                                          10.w,
                                          Text('Are you agree with this privacy policy ?', style: semiBold(fontSize: 12)),
                                        ],
                                      ),
                                      10.h,
                                      Obx(
                                        () => _controller.otpSent.value == false
                                            ? SizedBox.shrink()
                                            : Column(
                                                children: [
                                                  Text('OTP has been sent to your', style: semiBold(fontSize: 12, color: CustomColors().grey600)),
                                                  Text('mobile number, Please enter it below', style: semiBold(fontSize: 12, color: CustomColors().grey600)),
                                                  10.h,
                                                  Pinput(
                                                    onChanged: (val) async {
                                                      if (val.length == 6) {
                                                        Helper.showLoader();
                                                        await FirebaseOtpHelper().verifyOTP(otp: val).then((status) async {
                                                          Helper.closeLoader();
                                                          if (status.$1 == true) {
                                                            Map<String, dynamic> userDetail = status.$2;

                                                            final loginStatus = await _controller.login(mobileNo: userDetail['mobile']);
                                                            if (loginStatus.$1 == true) {
                                                              if ((loginStatus.$2['userStatus'] as String) == 'created') {
                                                                PreferenceService().setBoolean(key: AppConstants().prefKeyIsRegistered, value: true);
                                                                PreferenceService().setString(key: AppConstants().prefKeyMobile, value: _mobileController.text);
                                                              } else {
                                                                userDetail['userId'] = loginStatus.$2['userId'] ?? '';
                                                                userDetail['mobile'] = loginStatus.$2['mobile'] ?? '';
                                                                userDetail['name'] = loginStatus.$2['name'] ?? '';
                                                                userDetail['email'] = loginStatus.$2['email'] ?? '';
                                                                userDetail['panCard'] = loginStatus.$2['panCard'] ?? '';
                                                                userDetail['pinCode'] = loginStatus.$2['pinCode'] ?? '';
                                                                userDetail['address'] = loginStatus.$2['address'] ?? '';
                                                                userDetail['profileImage'] = loginStatus.$2['profileImage'] ?? '';
                                                                PreferenceService().setBoolean(key: AppConstants().prefKeyIsLoggedIn, value: true);
                                                              }

                                                              PreferenceService().setInt(key: AppConstants().prefKeyUserId, value: int.parse(loginStatus.$2['userId'] as String));
                                                              PreferenceService().setString(key: AppConstants().prefKeyUserDetail, value: json.encode(userDetail));
                                                              if ((loginStatus.$2['userStatus'] as String) == 'created') {
                                                                isUserRegistered.value = true;
                                                                isUserRegistered.refresh();
                                                              } else {
                                                                navigate(context: context, replace: true, path: homeRoute, param: widget.detail, removePreviousRoute: true);
                                                              }
                                                            } else {
                                                              Helper.showMessage(title: 'Error', message: loginStatus.$2['error'] as String, isSuccess: false);
                                                            }
                                                          } else {
                                                            Helper.showMessage(title: 'Error', message: 'Opt verification failed', isSuccess: false);
                                                          }
                                                        });
                                                      }
                                                    },
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    length: 6,
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                                                    defaultPinTheme: PinTheme(
                                                      width: 40,
                                                      height: 40,
                                                      textStyle: bolder(fontSize: 18, color: CustomColors().black),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        border: Border.all(color: CustomColors().grey500),
                                                      ),
                                                    ),
                                                    controller: _otpController,
                                                  ),
                                                ],
                                              ),
                                      ),
                                      20.h,
                                      CommonButton(
                                        onTap: () async {
                                          if (_formKey.currentState!.validate() && _mobileController.text.length == 10) {
                                            if (isPrivacyAccepted.value == true) {
                                              if (Platform.isAndroid) {
                                                Helper.showLoader();
                                                await FirebaseOtpHelper().sendOTP(mobile: '+91${_mobileController.text}').then((t) {
                                                  Helper.closeLoader();
                                                });
                                              } else {
                                                Map<String, dynamic> userDetail = {};
                                                Helper.showLoader();
                                                final loginStatus = await _controller.login(mobileNo: _mobileController.text);
                                                Helper.closeLoader();
                                                if (loginStatus.$1 == true) {
                                                  if ((loginStatus.$2['userStatus'] as String) == 'created') {
                                                    PreferenceService().setBoolean(key: AppConstants().prefKeyIsRegistered, value: true);
                                                  } else {
                                                    userDetail['userId'] = loginStatus.$2['userId'] ?? '';
                                                    userDetail['mobile'] = loginStatus.$2['mobile'] ?? '';
                                                    userDetail['name'] = loginStatus.$2['name'] ?? '';
                                                    userDetail['email'] = loginStatus.$2['email'] ?? '';
                                                    userDetail['panCard'] = loginStatus.$2['panCard'] ?? '';
                                                    userDetail['pinCode'] = loginStatus.$2['pinCode'] ?? '';
                                                    userDetail['address'] = loginStatus.$2['address'] ?? '';
                                                    userDetail['profileImage'] = loginStatus.$2['profileImage'] ?? '';
                                                    PreferenceService().setBoolean(key: AppConstants().prefKeyIsLoggedIn, value: true);
                                                  }

                                                  PreferenceService().setInt(key: AppConstants().prefKeyUserId, value: int.parse(loginStatus.$2['userId'] as String));
                                                  PreferenceService().setString(key: AppConstants().prefKeyUserDetail, value: json.encode(userDetail));
                                                  if ((loginStatus.$2['userStatus'] as String) == 'created') {
                                                    isUserRegistered.value = true;
                                                    isUserRegistered.refresh();
                                                  } else {
                                                    navigate(context: context, replace: true, path: homeRoute, param: widget.detail, removePreviousRoute: true);
                                                  }
                                                } else {
                                                  Helper.showMessage(title: 'Error', message: loginStatus.$2['error'] as String, isSuccess: false);
                                                }
                                              }
                                            }
                                          }
                                        },
                                        title: 'Send OTP',
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            validator: (val) {
              return null;
            },
            isMobile: true,
            readOnly: true,
            enabled: false,
            showMainTitle: false,
            formatter: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
            inputType: TextInputType.numberWithOptions(decimal: false, signed: true),
            controller: _mobileController,
            label: '',
            hint: '',
            errorMessage: '',
          ),
          10.h,
          CustomTextFormField(
            validator: (val) {
              if ((val ?? '').trim().isEmpty) {
                return 'નામ દાખલ કરો';
              }
              return null;
            },
            required: true,
            greyBorder: false,
            formatter: [formatterAllowOnlyAlphabetsWithSpace],
            controller: _controller.name,
            label: 'નામ*',
            hint: 'નામ દાખલ કરો',
            errorMessage: 'નામ દાખલ કરો',
          ),
          10.h,
          CustomTextFormField(
            validator: (val) {
              if ((val ?? '').trim().isEmpty || GetUtils.isEmail(val ?? '') == false) {
                return 'ઈમેલ દાખલ કરો';
              }
              return null;
            },
            greyBorder: false,
            required: true,
            isMobile: true,
            formatter: [formatterEmail],
            controller: _controller.email,
            inputType: TextInputType.emailAddress,
            label: 'ઈમેલ*',
            hint: 'ઈમેલ દાખલ કરો',
            errorMessage: 'ઈમેલ દાખલ કરો',
          ),
          10.h,
          Row(
            children: [
              InkWell(
                onTap: () {
                  isPrivacyAccepted.toggle();
                  if (isPrivacyAccepted.value == true) {
                    navigate(context: context, replace: false, path: policyRoute, param: {'title': 'Privacy Policy', 'data': widget.detail.aboutUs.privacyPolicy});
                  }
                },
                child: Obx(
                  () => Container(
                    alignment: .center,
                    decoration: BoxDecoration(
                      color: isPrivacyAccepted.value == true ? CustomColors().primaryColorDark : null,
                      borderRadius: BorderRadius.circular(0),
                      border: .all(color: CustomColors().grey600, width: 1),
                    ),
                    height: 18,
                    width: 18,

                    child: isPrivacyAccepted.value == true ? Icon(Icons.check, color: CustomColors().white, size: 12) : SizedBox.shrink(),
                  ),
                ),
              ),
              10.w,
              Text('Are you agree with this privacy policy ?', style: semiBold(fontSize: 12)),
            ],
          ),
          10.h,
          CommonButton(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                if (isPrivacyAccepted.value == true) {
                  Helper.showLoader();
                  await _controller.register(mobileNumber: _mobileController.text).then((result) {
                    Helper.closeLoader();
                    if (result.$1 == true) {
                      navigate(context: context, replace: true, path: homeRoute);
                    } else {
                      Helper.showMessage(title: 'Error', message: result.$2, isSuccess: false);
                    }
                  });
                }
              }
            },
            title: 'Done',
          ),
        ],
      ),
    );
  }
}
