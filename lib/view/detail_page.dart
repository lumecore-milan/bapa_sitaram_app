import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../constants/app_colors.dart';
import '../controllers/home_controller.dart';
import '../extensions/size_box_extension.dart';
import '../utils/font_styles.dart';
import '../utils/size_config.dart';
import '../widget/rounded_image.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key, required this.showAppbar, required this.eventIndex});
 final bool showAppbar;
 final int eventIndex;
  final _controller=Get.find<HomeDetailController>();
  @override
  Widget build(BuildContext context) {
    return showAppbar==false ? Scaffold(
      appBar: CustomAppbar(title: 'પ્રસંગ', showDrawerIcon: false, onBackTap: () { Navigator.pop(context); },),
      body: SafeArea(child: _getBody()),
    ):_getBody();
  }

  Widget _getBody(){
    return Container(
      height: SizeConfig().height,
      width: SizeConfig().width,
      child: SingleChildScrollView(
        child:
        Column(
          mainAxisSize: .min,
          children: [
            16.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Obx(
                        () => RoundedImage(
                      url:
                      _controller.homeDetail.value.events[eventIndex].eventImage,
                    ),
                  ),
                  16.h,
                  Text(
                          _controller.homeDetail.value.events[eventIndex].eventTitle,
                      style: bolder(
                        fontSize: 18,
                        color: CustomColors().black,
                      ),
                    ),
                ],
              ),
            ),
            Obx(
                  () => Padding(
                    padding: .symmetric(horizontal:16),
                    child: Html(
                                    data:
                                    _controller.homeDetail.value.events[eventIndex].eventDesc,
                                    style: {
                    "p": Style(
                      fontSize: FontSize(18),
                      color: Colors.black87,
                      textAlign: TextAlign.justify,
                      lineHeight: LineHeight(1.5),
                      fontFamily: "Hind Vadodara",
                    ),
                    "h4": Style(
                      fontSize: FontSize(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF962020),
                    ),
                    "div": Style(textAlign: TextAlign.justify),
                    "span": Style(fontSize: FontSize(18)),
                                    },
                                  ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
