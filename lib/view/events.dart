import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/rounded_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/controllers/home_controller.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/size_config.dart';

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
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemCount: _controller.homeDetail.value.events.length,
          itemBuilder: (_, index) {
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    navigate(context: context, replace: false, path: detailRoute, param: {'showAppbar': false, 'index': index});
                  },
                  child: RoundedImage(url: _controller.homeDetail.value.events[index].eventImage, height: 200, width: SizeConfig().width),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(_controller.homeDetail.value.events[index].eventTitle, style: semiBold(fontSize: 13, color: CustomColors().white)),
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
