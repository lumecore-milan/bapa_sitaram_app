import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../controllers/home_controller.dart';
import '../extensions/size_box_extension.dart';
import '../utils/font_styles.dart';
import '../utils/size_config.dart';
import '../widget/custom_html_widget.dart';
import '../widget/image_widget.dart';
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
      child:
      1>0 ?
      CustomHtmlWidget(content: _controller.homeDetail.value.events[eventIndex].eventDesc, title: _controller.homeDetail.value.events[eventIndex].eventTitle, image: _controller.homeDetail.value.events[eventIndex].eventImage,):

      SingleChildScrollView(
        child:
        Column(
          mainAxisSize: .min,
          children: [
            16.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:

              Column(
                crossAxisAlignment: .start,
                children: [
                  20.h,
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
                  5.h,
                 Row(
                   children: [
                     ImageWidget(
                       url: 'assets/images/ic_time.svg',
                       height: 14,
                       width: 14,
                       color: CustomColors().grey600,
                     ),
                     5.w,
                     Text(
                         HelperService().getFormattedDate (date: _controller.homeDetail.value.events[eventIndex].eventDate.toIso8601String(),outputFormat: 'dd MMM, yyyy')??'' ,
                          style: bolder(
                            fontSize: 12,
                            color: CustomColors().grey500,
                          ),
                        ),
                   ],
                 ),
                ],
              ),
            ),
            Obx(
                  () => Padding(
                    padding: .symmetric(horizontal:6),
                    child:
                    CustomHtmlWidget(content: _controller.homeDetail.value.events[eventIndex].eventDesc, title: _controller.homeDetail.value.events[eventIndex].eventTitle, image: _controller.homeDetail.value.events[eventIndex].eventImage,)
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
