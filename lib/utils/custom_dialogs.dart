import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/controllers/home_controller.dart';
import 'package:bapa_sitaram/services/download/download_helper_mobile.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:bapa_sitaram/widget/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/widget/image_widget.dart';
import 'package:bapa_sitaram/utils/helper.dart';

void showLoginDialog({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: CustomColors().layoutPrimaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                child: Icon(Icons.info, color: CustomColors().orange300, size: 60),
              ),
              20.h,
              Text('Login', style: bolder(fontSize: 18, color: CustomColors().black1000)),
              10.h,
              Text('Please Login First', style: medium(fontSize: 16, color: CustomColors().grey600)),
              25.h,
              CommonButton(
                width: 100,
                onTap: () {
                  final d = Get.find<HomeDetailController>().appSetting;
                  Navigator.pop(context);
                  navigate(context: context, replace: false, path: loginRoute, param: d);
                },
                title: 'OK',
                color: CustomColors().orange600,
                fullWidth: false,
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showDarshanTimeDialog1({required BuildContext context}) {
  final HomeDetailController controller = Get.find<HomeDetailController>();
  showDialog(
    context: context,
    barrierDismissible: false,
    fullscreenDialog: false,
    useSafeArea: true,
    useRootNavigator: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return SafeArea(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none, // allows close button to be clickable
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: SizeConfig().height - 350, minHeight: 250),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(color: CustomColors().layoutPrimaryBackground, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text('દર્શન સમય', style: semiBold(fontSize: 22, color: CustomColors().blue700)),
                      ),
                      8.h,
                      Image.asset('assets/images/ic_decore.png', height: 30, width: SizeConfig().width - 110, fit: BoxFit.fitWidth), // optional floral divider
                      10.h,
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.homeDetail.value.arti.data.length,
                          itemBuilder: (_, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageWidget(url: controller.homeDetail.value.arti.data[index].image, width: 30, height: 30),
                                10.w,
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(controller.homeDetail.value.arti.data[index].title, style: semiBold(fontSize: 16)),
                                      Text(controller.homeDetail.value.arti.data[index].descp, style: medium(fontSize: 16, color: CustomColors().grey600)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      /* Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/dt_1.png",
                            height: 30,
                            width: 30,
                          ),
                          // optional floral divider
                          10.w,
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "મંગલા આરતી:",
                                  style: semiBold(fontSize: 16),
                                ),
                                Text(
                                  "સવારે 5:00 કલાકે",
                                  style: medium(
                                    fontSize: 16,
                                    color: CustomColors().grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      12.h,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/dt_2.png",
                            height: 30,
                            width: 30,
                          ),
                          // optional floral divider
                          10.w,
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "રાજભોગ આરતી:",
                                  style: semiBold(fontSize: 16),
                                ),
                                Text(
                                  "બપોરે 12:00 કલાકે",
                                  style: medium(
                                    fontSize: 16,
                                    color: CustomColors().grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      12.h,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/dt_3.png",
                            height: 30,
                            width: 30,
                          ),
                          // optional floral divider
                          10.w,
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "સંધ્યા આરતી:",
                                  style: semiBold(fontSize: 16),
                                ),
                                Text(
                                  "સાંજના સમયે",
                                  style: medium(
                                    fontSize: 16,
                                    color: CustomColors().grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      12.h,
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/dt_4.png",
                            height: 30,
                            width: 30,
                          ),
                          // optional floral divider
                          10.w,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("દર્શન બંધ:", style: semiBold(fontSize: 16)),
                                Text(
                                  "રાત્રે 11:00 થી સવારે 5:00 કલાક સુધી",
                                  style: medium(
                                    fontSize: 16,
                                    color: CustomColors().grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),*/
                      16.h,
                      Text('ચૌદશ અને પૂનમમાં દર્શન 24 કલાક ચાલુ રહેશે.', style: semiBold(fontSize: 16), textAlign: TextAlign.center),
                      16.h,
                      Image.asset('assets/images/ic_decore.png', height: 30, width: SizeConfig().width - 110, fit: BoxFit.fitWidth),
                    ],
                  ),
                ),
                Container(height: 100),
                Positioned(
                  bottom: -60,
                  left: (SizeConfig().width / 2) - 14,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showDarshanTimeDialog({required BuildContext context}) {
  final HomeDetailController controller = Get.find<HomeDetailController>();

  showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    useRootNavigator: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return SafeArea(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none, // IMPORTANT
              children: [
                Container(
                  color: Colors.transparent,
                  constraints: const BoxConstraints(maxHeight: 500, minHeight: 400),
                  padding: const .symmetric(vertical: 50),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 370),
                    padding: const EdgeInsets.all(16),
                    margin: const .only(bottom: 20),
                    decoration: BoxDecoration(color: CustomColors().layoutPrimaryBackground, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text('દર્શન સમય', style: semiBold(fontSize: 22, color: CustomColors().blue700)),
                        ),

                        8.h,

                        Image.asset('assets/images/ic_decore.png', height: 30, width: SizeConfig().width - 110, fit: BoxFit.fitWidth),

                        10.h,

                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (_, index) {
                           

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageWidget(url: 'assets/images/dt_${index + 1}.png', width: 30, height: 30),
                                10.w,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(['મંગળા આરતી', 'રાજભોગ આરતી', 'સંધ્યા આરતી'][index], style: semiBold(fontSize: 16)),
                                      Text(
                                        index == 0
                                            ? controller.homeDetail.value.darshanTime.manglaArti
                                            : index == 1
                                            ? controller.homeDetail.value.darshanTime.rajbhogArti
                                            : controller.homeDetail.value.darshanTime.sandhyaArti,
                                        style: medium(fontSize: 16, color: CustomColors().grey600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        16.h,

                        Text(controller.homeDetail.value.darshanTime.note, style: semiBold(fontSize: 16), textAlign: TextAlign.center),

                        16.h,

                        Image.asset('assets/images/ic_decore.png', height: 30, width: SizeConfig().width - 110, fit: BoxFit.fitWidth),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, // now clickable
                  left: (SizeConfig().width / 2) - 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void rateUsDialog({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: CustomColors().white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none, // allow overflow
              children: [
                Container(
                  height: 100,
                  width: SizeConfig().width,
                  decoration: BoxDecoration(
                    color: CustomColors().orange600,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                  ),
                ),
                Positioned(
                  top: 40, // half outside
                  left: ((SizeConfig().width * 0.70) / 2) - 40,
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    padding: const .all(10),
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: CustomColors().white),
                      padding: const .all(10),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                        child: const ImageWidget(url: 'assets/images/five_star.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const .all(10),
              child: Column(
                children: [
                  40.h,
                  Text('Rate Our App', style: bolder(fontSize: 18, color: CustomColors().black1000)),
                  10.h,
                  Text('If you enjoyed our app. Would you mind rating us on Play Store.', style: semiBold(fontSize: 14, color: CustomColors().grey600)),
                  25.h,
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      CommonButton(
                        fontSize: 14,
                        width: 110,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        title: 'May be Later',
                        color: CustomColors().grey500,
                        fullWidth: false,
                      ),
                      10.w,
                      CommonButton(
                        fontSize: 14,
                        width: 110,
                        onTap: () async {
                          Navigator.pop(context);
                          await Helper.launch(url: 'https://play.google.com/store/apps/details?id=com.bapasitaram.bagdana&hl=en_IN');
                        },
                        title: 'Rate Now',
                        color: CustomColors().blue700,
                        fullWidth: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void downloadProgress({required Rx<double> progress, required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: CustomColors().layoutPrimaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                child: Obx(() {
                  if (progress.value >= 100) {
                    Future.microtask(() {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    });
                  }
                  return LinearProgressIndicator(value: (progress.value) / 100, borderRadius: .circular(10), color: CustomColors().primaryColorDark, backgroundColor: CustomColors().grey500);
                }),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void downloadReceiptDialog({required BuildContext context, required dynamic detail, required String url}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    useRootNavigator: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return SafeArea(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none, // IMPORTANT
              children: [
                Container(
                  color: Colors.transparent,
                  constraints: BoxConstraints(maxHeight: SizeConfig().height - 250),
                  padding: const .symmetric(vertical: 70),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: CustomColors().layoutPrimaryBackground, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text('Donation for', style: semiBold(fontSize: 22, color: CustomColors().blue700)),
                        ),

                        8.h,
                        Center(child: Text('અન્નક્ષેત્ર', style: bolder(fontSize: 22))),

                        10.h,
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          crossAxisAlignment: .center,
                          children: [
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text('Amount', style: semiBold(fontSize: 16)),
                                Text('${detail['amount'] ?? ''}', style: bolder(fontSize: 16, color: CustomColors().green700)),
                              ],
                            ),
                            Text('COMPLETED', style: bolder(fontSize: 18, color: CustomColors().green700)),
                          ],
                        ),
                        10.h,
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          crossAxisAlignment: .center,
                          children: [
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text('Payment ID', style: semiBold(fontSize: 16)),
                                Text(detail['payment_id'], style: medium(fontSize: 16, color: CustomColors().grey600)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text('Date', style: semiBold(fontSize: 16)),
                                Text(detail['payment_date'], style: medium(fontSize: 16, color: CustomColors().grey600)),
                              ],
                            ),
                          ],
                        ),
                        10.h,
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text('Your Detail', style: semiBold(fontSize: 16)),
                            Text(detail['name'] ?? '', style: medium(fontSize: 16, color: CustomColors().grey600)),
                            Text(detail['mobile'] ?? '', style: medium(fontSize: 16, color: CustomColors().grey600)),
                            Text(detail['email'] ?? '', style: medium(fontSize: 16, color: CustomColors().grey600)),
                          ],
                        ),
                        10.h,
                        Text('Your Address', style: medium(fontSize: 16)),
                        Text(detail['address'] ?? '', style: medium(fontSize: 16, color: CustomColors().grey600)),
                        20.h,
                        CommonButton(
                          color: CustomColors().blue700,
                          onTap: () async {
                            Helper.showLoader();
                            await DownloadServiceMobile().download(url: url).then((d) async {
                              Helper.closeLoader();
                              Navigator.pop(context);
                              if (d != null) {
                                final result = await OpenFilex.open(d);

                                if (result.type == ResultType.done) {
                                } else {
                                  Helper.showMessage(title: 'Download', message: 'Receipt Downloaded at $d', isSuccess: true, durationInSecond: 5);
                                }
                              } else {
                                Helper.showMessage(title: 'Download', message: 'Receipt Downloaded at $d', isSuccess: true, durationInSecond: 5);
                              }
                            });
                          },
                          title: 'Download Receipt',
                        ),
                      ],
                    ),
                  ),
                ),

                /// CLOSE BUTTON
                Positioned(
                  bottom: 0, // now clickable
                  left: (SizeConfig().width / 2) - 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: .circular(10)),
                      child: const Icon(Icons.close, color: Colors.black, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void noInternetDialog() {
  
  
  Helper.showMessage(title: 'No Internet Connection', message: 'No Internet Connection. Please check your network settings and try again.', isSuccess: false);
  
  AppConstants().isDialogOpen = true;
  /*showDialog(
    context: AppConstants().navigatorKey.currentContext!,
    barrierDismissible: false,
    useSafeArea: true,
    useRootNavigator: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return PopScope(
        canPop: false,
        child: SafeArea(
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 150),
                padding: const EdgeInsets.all(16),
                margin: const .all(40),
                decoration: BoxDecoration(color: CustomColors().layoutPrimaryBackground, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text('No Internet', style: semiBold(fontSize: 22, color: CustomColors().blue700)),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );*/
}

void appUpdateDialog({required BuildContext context, required String title, required String message, bool forceUpdate = false}) {
  showDialog(
    context: context,
    barrierDismissible: forceUpdate == true ? false : true,
    useSafeArea: true,
    useRootNavigator: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return SafeArea(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none, // IMPORTANT
              children: [
                Container(
                  color: Colors.transparent,
                  constraints: const BoxConstraints(maxHeight: 350, minHeight: 350),
                  padding: const .symmetric(vertical: 50),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 350),
                    padding: const EdgeInsets.all(16),
                    margin: const .only(bottom: 20),
                    decoration: BoxDecoration(color: CustomColors().layoutPrimaryBackground, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(title, style: semiBold(fontSize: 22, color: CustomColors().blue700)),
                        ),
                        8.h,
                        Text(message, textAlign: TextAlign.left, softWrap: true, maxLines: null, overflow: TextOverflow.visible, style: semiBold(fontSize: 16)),
                        15.h,
                        Expanded(
                          child: Align(
                            alignment: .bottomCenter,
                            child: SizedBox(
                              height: 50,
                              child: CommonButton(
                                color: CustomColors().blue700,
                                onTap: () async {
                                  await HelperService().openAppStore();
                                },
                                title: 'Update',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (forceUpdate == false)
                  Positioned(
                    bottom: 0, // now clickable
                    left: (SizeConfig().width / 2) - 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 28),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
