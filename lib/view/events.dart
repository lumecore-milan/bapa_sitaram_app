import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/rounded_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/routes.dart';
import '../controllers/home_controller.dart';
import '../utils/font_styles.dart';
import '../utils/size_config.dart';

class EventsPage extends StatelessWidget {
  EventsPage({super.key});
  final _controller = Get.find<HomeDetailController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'પ્રસંગ',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, index) => SizedBox(height: 10),
          itemCount: _controller.homeDetail.value.events.length,
          itemBuilder: (_, index) {
            print(_controller.homeDetail.value.events[index].eventId);
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    navigate(
                      context: context,
                      replace: false,
                      path: detailRoute,
                      param: {'showAppbar': false, 'index': index},
                    );
                  },
                  child: RoundedImage(
                    url: _controller.homeDetail.value.events[index].eventImage,
                    height: 200,
                    width: SizeConfig().width,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      _controller.homeDetail.value.events[index].eventTitle,
                      style: semiBold(
                        fontSize: 13,
                        color: CustomColors().white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
