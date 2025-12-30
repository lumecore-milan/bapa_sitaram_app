import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/controllers/home_controller.dart';
import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:bapa_sitaram/widget/custom_html_widget.dart';
import 'package:bapa_sitaram/widget/image_widget.dart';
import 'package:bapa_sitaram/widget/rounded_image.dart';

class DetailPage extends StatelessWidget {
  DetailPage({required this.showAppbar, required this.eventIndex, super.key});
  final bool showAppbar;
  final int eventIndex;
  final _controller = Get.find<HomeDetailController>();
  @override
  Widget build(BuildContext context) {
    return showAppbar == false
        ? Scaffold(
            appBar: CustomAppbar(
              title: 'પ્રસંગ',
              showDrawerIcon: false,
              onBackTap: () {
                Navigator.pop(context);
              },
            ),
            body: SafeArea(child: _getBody()),
          )
        : _getBody();
  }

  Widget _getBody() {
    return SizedBox(
      height: SizeConfig().height,
      width: SizeConfig().width,
      child: 1 > 0
          ? CustomHtmlWidget(content: _controller.homeDetail.value.events[eventIndex].eventDesc, title: _controller.homeDetail.value.events[eventIndex].eventTitle, image: _controller.homeDetail.value.events[eventIndex].eventImage)
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: .min,
                children: [
                  16.h,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        20.h,
                        Obx(() => RoundedImage(url: _controller.homeDetail.value.events[eventIndex].eventImage)),
                        16.h,
                        Text(_controller.homeDetail.value.events[eventIndex].eventTitle, style: bolder(fontSize: 18, color: CustomColors().black)),
                        5.h,
                        Row(
                          children: [
                            ImageWidget(url: 'assets/images/ic_time.svg', height: 14, width: 14, color: CustomColors().grey600),
                            5.w,
                            Text(
                              HelperService().getFormattedDate(date: _controller.homeDetail.value.events[eventIndex].eventDate.toIso8601String(), outputFormat: 'dd MMM, yyyy') ?? '',
                              style: bolder(fontSize: 12, color: CustomColors().grey500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const .symmetric(horizontal: 6),
                      child: CustomHtmlWidget(content: _controller.homeDetail.value.events[eventIndex].eventDesc, title: _controller.homeDetail.value.events[eventIndex].eventTitle, image: _controller.homeDetail.value.events[eventIndex].eventImage),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
