import 'dart:math';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/controllers/punam_list_controller.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../extensions/size_box_extension.dart';
import '../services/loger_service.dart';

class PunamListPage extends StatelessWidget {
  PunamListPage({super.key});

  final PunamListController _controller = Get.put(PunamListController());
  int minIndex = -1;
  final Color kYellowText = CustomColors().yellow600;
  bool isMinDate({required int index}) {
    try {
      DateTime? currentDate = DateTime.now();
      String temp = _controller.list.value.poonamList[index].date.substring(
        _controller.list.value.poonamList[index].date.lastIndexOf(':') + 1,
      );
      List<String> f = temp.split('/');
      temp = "${f[2]}-${f[1]}-${f[0]}";
      if (temp.isNotEmpty) {
        DateTime d = DateTime.parse(temp);
        if (currentDate.isBefore(d) || DateUtils.isSameDay(currentDate, d)) {
          return true;
        }
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return false;
  }

  int getMinIndex(){
        DateTime? currentDate = DateTime.now();
        for(int i=0;i< _controller.list.value.poonamList.length;i++){

          try {
            String temp = _controller.list.value.poonamList[i].date.substring(
              _controller.list.value.poonamList[i].date.lastIndexOf(':') + 1,
            );
            List<String> f = temp.split('/');
            temp = "${f[2]}-${f[1]}-${f[0]}";
            if (temp.isNotEmpty) {
              DateTime d = DateTime.parse(temp);
              if (d.isAfter(currentDate)||  DateUtils.isSameDay(currentDate, d)) {
                return i;
              }
            }
          } catch (e) {
            LoggerService().log(message: e.toString());
          }
        }
        return _controller.list.value.poonamList.length - 1;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => ListView.builder(
              itemCount: _controller.list.value.poonamList.length,
              itemBuilder: (_, index) {
                minIndex=getMinIndex();
                return IntrinsicHeight(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 5,
                              height:
                                  index <
                                      _controller.list.value.poonamList.length
                                  ? null
                                  : 20,
                              color:   index <=minIndex
                                  ? CustomColors().primaryColorDark
                                  : CustomColors().grey600,
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                alignment: .center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:  index<minIndex
                                      ? CustomColors().primaryColorDark
                                      : CustomColors().white,
                                  border: Border.all(
                                    color: CustomColors().grey600,
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index<minIndex
                                        ? CustomColors().white
                                        :  index==minIndex ?

                                    CustomColors().primaryColorDark:

                                    CustomColors().grey600,
                                  ),
                                ),
                              ),
                              if(index==minIndex)
                                Positioned(
                                    top: -10,
                                    left: -10,
                                    child: LottieBuilder.asset('assets/animation/pulse.json',height: 50,width: 50,))
                            ],
                          ),

                          Expanded(
                            child: Container(
                              width: 5,
                              color:
                                  index ==
                                      _controller.list.value.poonamList.length -
                                          1
                                  ? Colors.transparent
                                  :   index >= minIndex
                                  ? CustomColors().grey600
                                  : CustomColors().primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 16, bottom: 20),
                          padding: .symmetric(horizontal: 10, vertical: 10),
                          alignment: .centerLeft,
                          decoration: BoxDecoration(
                            color: _controller.list.value.poonamList[index].spacial ?   randomBgForYellow(): CustomColors().white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                _controller.list.value.poonamList[index].title,
                                style: bolder(
                                  fontSize: 20,
                                  color:_controller.list.value.poonamList[index].spacial ? kYellowText:    CustomColors().black1000,
                                ),
                              ),
                              6.h,
                              Text(
                                _controller.list.value.poonamList[index].date,
                                style: bolder(
                                  fontSize: 16,
                                  color:_controller.list.value.poonamList[index].spacial ? kYellowText:   CustomColors().grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }


  Color randomBgForYellow({double minContrast = 4.5, int maxAttempts = 1000}) {
    final Random rnd = Random();
    for (int i = 0; i < maxAttempts; i++) {
      final Color c = Color.fromARGB(
        0xFF,
        rnd.nextInt(256),
        rnd.nextInt(256),
        rnd.nextInt(256),
      );

      if (contrastRatio(c, kYellowText) >= minContrast) {
        return c;
      }
    }

    // Fallback: a safe dark background that gives excellent contrast for yellow text.
    // You can tweak this or return Colors.black
    return const Color(0xFF111111);
  }

  /// Returns contrast ratio between two colors as (L1 + 0.05) / (L2 + 0.05)
  /// Where L1 >= L2 are relative luminances according to WCAG.
  double contrastRatio(Color a, Color b) {
    final double la = _relativeLuminance(a);
    final double lb = _relativeLuminance(b);
    final double L1 = max(la, lb);
    final double L2 = min(la, lb);
    return (L1 + 0.05) / (L2 + 0.05);
  }

  /// Convert sRGB color channel [0..255] to linearized value per WCAG:
  /// if (c <= 0.03928) -> c/12.92 else -> ((c + 0.055)/1.055)^2.4
  double _linearizeChannel(int channel) {
    final double s = channel / 255.0;
    if (s <= 0.03928) return s / 12.92;
    return pow((s + 0.055) / 1.055, 2.4).toDouble();
  }

  /// Compute relative luminance: 0.2126*R + 0.7152*G + 0.0722*B
  double _relativeLuminance(Color color) {
    final double r = _linearizeChannel(color.red);
    final double g = _linearizeChannel(color.green);
    final double b = _linearizeChannel(color.blue);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }



}
