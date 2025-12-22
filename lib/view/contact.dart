/*import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_module/flutter_core_module.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ImageWidget(url: '',height: 150,width: SizeConfig().width,),
            12.h,
            Text('Bapa Sitaram temple - Teerth Kshetra Bagdana Dham',style: bolder(
                fontSize: 16,color: CustomColors().red500
            ),),
            10.h,
            Text('Bapa Sitaram temple - Teerth Kshetra Bagdana Dham',style: medium(
                fontSize: 14,color: CustomColors().red500
            ),),
            10.h,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ImageWidget(height: 24,width: 24,url: 'assets/images/ic_email.svg'),
                    5.w,
                    Text('Bapa Sitaram temple - Teerth Kshetra Bagdana Dham',style: medium(
                        fontSize: 12,color: CustomColors().red500
                    ),),
                  ],
                ),
                10.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ImageWidget(height: 24,width: 24,url: 'assets/images/ic_phone.svg'),
                    5.w,
                    Text('Bapa Sitaram temple - Teerth Kshetra Bagdana Dham',style: medium(
                        fontSize: 12,color: CustomColors().red500
                    ),),
                  ],
                ),
                10.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ImageWidget(height: 24,width: 24,url: 'assets/images/ic_phone.svg'),
                    5.w,
                    Text('Bapa Sitaram temple - Teerth Kshetra Bagdana Dham',style: medium(
                        fontSize: 12,color: CustomColors().red500
                    ),),
                  ],
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

*/

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import '../constants/api_constant.dart';
import '../controllers/home_controller.dart';
import '../extensions/size_box_extension.dart';
import '../services/loger_service.dart';

import '../services/network/api_mobile.dart';
import '../utils/helper.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_field.dart';
import '../widget/image_widget.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final HomeDetailController controller = Get.find<HomeDetailController>();

  final TextEditingController type = TextEditingController();

  final TextEditingController name = TextEditingController();

  final TextEditingController mobile = TextEditingController();

  final TextEditingController amount = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController pinCode = TextEditingController();

  final TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Contact Us',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                10.h,
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: .all(10),
                    decoration: BoxDecoration(
                      borderRadius: .circular(10),
                      color: CustomColors().white,
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors().green50,
                          blurRadius: 10,
                          spreadRadius: 2, // keep this 0 for OUTSIDE only
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        _contactDetail(image: 'assets/images/ic_phone.svg', title: 'મોબાઈલ  નંબર', value: controller.aboutUs['about_phone']),
                        _contactDetail(image: 'assets/images/ic_email.svg', title: 'ઈમેલ', value: controller.aboutUs['about_email']),
                        _contactDetail(image: 'assets/images/ic_address.svg', title: 'સરનામું', value: controller.aboutUs['address']),
                      ],
                    ),
                  ),
                ),
                20.h,
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
                        controller: name,
                        label: 'નામ*',
                        hint: 'નામ દાખલ કરો',
                        errorMessage: 'નામ દાખલ કરો',
                      ),
                      10.h,
                      CustomTextFormField(
                        validator: (val) {
                          if ((val ?? '').trim().length != 10) {
                            return 'મોબાઈલ નંબર દાખલ કરો';
                          }
                          return null;
                        },
                        greyBorder: true,
                        required: true,
                        isMobile: true,
                        formatter: [formatterDigitsOnly, LengthLimitingTextInputFormatter(10)],
                        inputType: TextInputType.numberWithOptions(decimal: false, signed: true),
                        controller: mobile,
                        label: 'મોબાઈલ  નંબર*',
                        hint: 'મોબાઈલ  નંબર દાખલ કરો',
                        errorMessage: 'મોબાઈલ નંબર દાખલ કરો',
                      ),
                      10.h,
                      CustomTextFormField(
                        validator: (val) {
                          if ((val ?? '').trim().isEmpty || GetUtils.isEmail(val ?? '') == false) {
                            return 'ઈમેલ દાખલ કરો';
                          }
                          return null;
                        },
                        greyBorder: true,
                        required: true,
                        isMobile: true,
                        formatter: [formatterEmail],
                        inputType: TextInputType.emailAddress,
                        controller: email,
                        label: 'ઈમેલ*',
                        hint: 'ઈમેલ દાખલ કરો',
                        errorMessage: 'ઈમેલ દાખલ કરો',
                      ),
                      10.h,
                      CustomTextFormField(
                        validator: (val) {
                          if ((val ?? '').trim().isEmpty) {
                            return 'સંદેશ દાખલ કરો';
                          }
                          return null;
                        },
                        greyBorder: true,
                        required: true,
                        maxLines: 5,
                        isMobile: true,
                        formatter: [LengthLimitingTextInputFormatter(200)],
                        controller: message,
                        inputType: TextInputType.streetAddress,
                        label: 'સંદેશ*',
                        hint: 'સંદેશ',
                        errorMessage: 'સંદેશ દાખલ કરો',
                      ),

                      20.h,
                      CommonButton(
                        color: CustomColors().blue700,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              Helper.showLoader();
                              await NetworkServiceMobile().post(url: APIConstant().apiContactUs, requestBody: {'name': name.text, 'mobile_no': mobile.text, 'email': email.text, 'message': message.text}, isFormData: true).then((data) {
                                Helper.closeLoader();
                                Helper.showMessage(title: data['httpStatusCode'] == 200 ? 'Success' : "Error", message: data['message'], isSuccess: data['httpStatusCode'] == 200);

                                if (data['httpStatusCode'] == 200) {
                                  name.clear();
                                  mobile.clear();
                                  email.clear();
                                  message.clear();
                                  _formKey.currentState?.reset();
                                }
                              });
                            } catch (e) {
                              LoggerService().log(message: e.toString());
                            }
                          }
                        },
                        title: 'સંદેશ મોકલો',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactDetail({required String image, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: .center,
        mainAxisAlignment: .start,
        children: [
          ImageWidget(url: image, color: CustomColors().primaryColorDark, height: 24, width: 24),
          10.w,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(title, style: bolder(fontSize: 14, color: CustomColors().black1000)),

                Text(value, style: bolder(fontSize: 12, color: CustomColors().grey600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
