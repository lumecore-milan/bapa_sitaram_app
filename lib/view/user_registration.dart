import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/controllers/registration_controller.dart';
import 'package:bapa_sitaram/services/enums.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/utils/helper.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:bapa_sitaram/widget/custom_button.dart';
import 'package:bapa_sitaram/widget/custom_text_field.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final RegistrationController _controller = Get.put(RegistrationController());
  Rx<bool> isPrivacyAccepted = false.obs;
  @override
  void dispose() {
    Get.delete<RegistrationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'પ્રોફાઈલ',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  160.h,

                  Container(
                    decoration: BoxDecoration(color: CustomColors().layoutPrimaryBackground),
                    child: Padding(
                      padding: const .only(top: 16, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                10.h,
                                CustomTextFormField(
                                  validator: (val) {
                                    if ((val ?? '').trim().isEmpty) {
                                      return 'નામ દાખલ કરો';
                                    }
                                    return null;
                                  },
                                  required: true,
                                  greyBorder: true,
                                  formatter: [formatterAllowOnlyAlphabetsWithSpace],
                                  controller: _controller.name,
                                  label: 'નામ*',
                                  hint: 'નામ દાખલ કરો',
                                  errorMessage: 'નામ દાખલ કરો',
                                ),
                                10.h,
                                CustomTextFormField(
                                  validator: (val) {
                                    return null;
                                  },
                                  isMobile: true,
                                  readOnly: true,
                                  required: false,
                                  enabled: false,
                                  showMainTitle: true,
                                  formatter: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                                  inputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                                  controller: _controller.mobile,
                                  label: 'મોબાઇલ',
                                  hint: '',
                                  errorMessage: '',
                                ),
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
                                CustomTextFormField(
                                  validator: (val) {
                                    if ((val ?? '').isNotEmpty && (val ?? '').trim().length != 10) {
                                      return 'પાનકાર્ડ નંબર દાખલ કરો';
                                    }
                                    return null;
                                  },
                                  greyBorder: false,
                                  required: false,
                                  isMobile: false,
                                  formatter: [PanCardInputFormatter1()],
                                  controller: _controller.panCard,
                                  label: 'પાનકાર્ડ નંબર',
                                  hint: 'પાનકાર્ડ નંબર દાખલ કરો',
                                  errorMessage: 'પાનકાર્ડ નંબર દાખલ કરો',
                                ),
                                10.h,
                                CustomTextFormField(
                                  validator: (val) {
                                    if ((val ?? '').isNotEmpty && (val ?? '').trim().length != 6) {
                                      return 'પીનકોડ દાખલ કરો';
                                    }
                                    return null;
                                  },
                                  greyBorder: false,
                                  isMobile: false,
                                  required: false,
                                  formatter: [formatterPostalCodeLength, formatterDigitsOnly],
                                  inputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                                  controller: _controller.pinCode,
                                  label: 'પીનકોડ',
                                  hint: 'પીનકોડ દાખલ કરો',
                                  errorMessage: 'પીનકોડ દાખલ કરો',
                                ),
                                10.h,

                                CustomTextFormField(
                                  validator: (val) {
                                    return null;
                                  },
                                  greyBorder: false,
                                  required: false,
                                  maxLines: 4,
                                  isMobile: false,
                                  formatter: [LengthLimitingTextInputFormatter(200)],
                                  controller: _controller.address,
                                  label: 'સરનામું',
                                  hint: 'સરનામું',
                                  errorMessage: 'સરનામું દાખલ કરો',
                                ),
                                10.h,

                                CommonButton(
                                  color: CustomColors().green900,
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Helper.showLoader();
                                      await _controller.register().then((result) {
                                        Helper.closeLoader();
                                        if (result.$1 == true) {
                                           if (mounted && context.mounted) {
                                          navigate(context: context, replace: true, path: homeRoute);
                                           }
                                        } else {
                                          Helper.showMessage(title: 'Error', message: result.$2, isSuccess: false);
                                        }
                                      });
                                    }
                                  },
                                  title: 'Register',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 150,
                        width: SizeConfig().width,
                        decoration: BoxDecoration(color: CustomColors().white),
                        child: Image.asset('assets/images/bg_image.jpeg', fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 150 - 40, // half outside
                    left: ((SizeConfig().width) / 2) - 40,
                    child: Stack(
                      children: [
                        Container(
                          height: 80,
                          width: 80,

                          decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                          child: Obx(
                            () => ClipOval(
                              child: ImageWidget(url: _controller.profileImagePath.value, fit: .cover, height: 80, width: 80),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -0,
                          top: 0,
                          child: InkWell(
                            onTap: () async {
                              final String? path = await HelperService().pickFile(fileType: AllowedFileType.image);
                              if (path != null) {
                                _controller.profileImagePath.value = path;
                                _controller.profileImagePath.refresh();
                              }
                            },
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                              child: const Icon(Icons.edit, size: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
