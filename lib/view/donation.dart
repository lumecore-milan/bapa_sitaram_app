import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/services/enums.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bapa_sitaram/controllers/donation_controller.dart';
import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/services/app_events.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:bapa_sitaram/utils/custom_dialogs.dart';
import 'package:bapa_sitaram/utils/helper.dart';
import 'package:bapa_sitaram/widget/custom_button.dart';
import 'package:bapa_sitaram/widget/custom_text_field.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key, this.showAppBar = false});
  final bool showAppBar;
  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final DonationController _controller = Get.put(DonationController());
  final items = ['અન્નક્ષેત્ર', 'કેપવાણી', 'ચિકિત્સા સેવા', 'ખાદ્યદાન', 'વૃક્ષારોપણ/પર્યાવરણ', 'ગૌસેવા', 'કૂટિર ઉદ્યોગ સહાય', 'સામાજિક સેવા', 'માનવ સેવા'];

  @override
  void initState() {
    AppEventsStream().stream.listen((event) {
      if (event.type == AppEventType.paymentSuccess) {
        navigate(context: context, replace: false, path: myDonationRoute);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<DonationController>();
    super.dispose();
  }

  String getInitialItem() {
    return items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar == false
          ? null
          : CustomAppbar(
              title: 'ડોનેશન',
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
                Text('નોંધ : દાનની રસીદ મેળવવા માટે કૃપા કરી નીચેની પ્રક્રિયા અનુસરો . કર કપાતપાત્ર યોગદાન માટે ચુકવણી રસીદો  માટે માન્ય સંપર્ક માહિતી જરૂર પડશે.', style: bolder(fontSize: 12, color: CustomColors().grey500)),
                20.h,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        selectedItem: _controller.type.text.isEmpty ? getInitialItem() : _controller.type.text,
                        validator: (val) {
                          if ((val ?? '').trim().isEmpty) {
                            return 'દાનનો પ્રકાર પસંદ કરો';
                          }
                          return null;
                        },
                        required: true,
                        isDropDown: true,
                        greyBorder: false,
                        formatter: [LengthLimitingTextInputFormatter(50)],
                        controller: _controller.type,
                        label: 'દાનનો પ્રકાર *',
                        hint: '',
                        onChanged: (val) {
                          _controller.type.text = val;
                        },
                        dropDownItems: items,
                        errorMessage: 'દાનનો પ્રકાર પસંદ કરો',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              validator: (val) {
                                if ((val ?? '').trim().isEmpty) {
                                  return 'મોબાઈલ નંબર દાખલ કરો';
                                }
                                return null;
                              },
                              greyBorder: false,
                              required: true,
                              isMobile: true,
                              formatter: [LengthLimitingTextInputFormatter(10), formatterDigitsOnly],
                              inputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                              controller: _controller.mobile,
                              label: 'મોબાઈલ  નંબર*',
                              hint: 'મોબાઈલ  નંબર દાખલ કરો',
                              errorMessage: 'મોબાઈલ નંબર દાખલ કરો',
                            ),
                          ),
                          10.w,
                          Expanded(
                            child: CustomTextFormField(
                              validator: (val) {
                                if ((val ?? '').trim().isEmpty) {
                                  return 'રકમ દાખલ કરો';
                                }
                                return null;
                              },
                              greyBorder: false,
                              required: true,
                              formatter: [LengthLimitingTextInputFormatter(10), formatterDigitsOnly],
                              inputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                              controller: _controller.amount,
                              label: 'રકમ',
                              hint: 'રકમ',
                              errorMessage: 'રકમ દાખલ કરો',
                            ),
                          ),
                        ],
                      ),
                      10.h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomTextFormField(
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
                          ),
                          10.w,
                          Expanded(
                            child: CustomTextFormField(
                              validator: (val) {
                                if ((val ?? '').trim().length != 6) {
                                  return 'પીનકોડ દાખલ કરો';
                                }
                                return null;
                              },
                              greyBorder: false,
                              isMobile: true,
                              required: true,
                              formatter: [formatterPostalCodeLength, formatterDigitsOnly],
                              inputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                              controller: _controller.pinCode,
                              label: 'પીનકોડ*',
                              hint: 'પીનકોડ દાખલ કરો',
                              errorMessage: 'પીનકોડ દાખલ કરો',
                            ),
                          ),
                        ],
                      ),
                      10.h,
                      CustomTextFormField(
                        validator: (val) {
                          if ((val ?? '').trim().length != 10) {
                            return 'પાનકાર્ડ નંબર દાખલ કરો';
                          }
                          return null;
                        },
                        greyBorder: false,
                        required: true,
                        isMobile: true,
                        formatter: [PanCardInputFormatter1()],
                        controller: _controller.panCard,
                        label: 'પાનકાર્ડ નંબર*',
                        hint: 'પાનકાર્ડ નંબર દાખલ કરો',
                        errorMessage: 'પાનકાર્ડ નંબર દાખલ કરો',
                      ),
                      10.h,
                      CustomTextFormField(
                        validator: (val) {
                          if ((val ?? '').trim().isEmpty) {
                            return 'સરનામું દાખલ કરો';
                          }
                          return null;
                        },
                        greyBorder: false,
                        required: true,
                        maxLines: 5,
                        isMobile: true,
                        formatter: [LengthLimitingTextInputFormatter(200)],
                        controller: _controller.address,
                        label: 'સરનામું*',
                        hint: 'સરનામું',
                        errorMessage: 'સરનામું દાખલ કરો',
                      ),
                      10.h,
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _controller.isPrivacyAccepted.toggle();
                            },
                            child: Obx(
                              () => Container(
                                alignment: .center,
                                decoration: BoxDecoration(
                                  color: _controller.isPrivacyAccepted.value == true ? CustomColors().primaryColorDark : null,
                                  borderRadius: BorderRadius.circular(0),
                                  border: .all(color: CustomColors().grey600, width: 1),
                                ),
                                height: 18,
                                width: 18,

                                child: _controller.isPrivacyAccepted.value == true ? Icon(Icons.check, color: CustomColors().white, size: 12) : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                          10.w,
                          Text('મેં નિયમો અને શરતો વાંચી છે અને આથી તે સાથે સંમત છુ.', style: semiBold(fontSize: 12, color: CustomColors().grey600)),
                        ],
                      ),
                      20.h,
                      CommonButton(
                        color: CustomColors().green900,
                        onTap: () async {
                          if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn)) {
                            if (_formKey.currentState!.validate()) {
                              if (_controller.isPrivacyAccepted.value == true) {
                                Helper.showLoader();
                                await _controller.submit().then((resp) {
                                  Helper.closeLoader();
                                });
                              }
                            }
                          } else {
                            showLoginDialog(context: context);
                          }
                        },
                        title: 'Process To Donate',
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
}
