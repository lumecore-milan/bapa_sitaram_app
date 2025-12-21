import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/utils/events.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

import '../controllers/home_controller.dart';
import '../extensions/size_box_extension.dart';
import '../utils/helper.dart';
import '../utils/size_config.dart';
import '../widget/image_widget.dart';
import '../widget/marquee_text.dart';
import '../widget/rounded_image.dart';

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({super.key});

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  final HomeDetailController _controller = Get.put(
    HomeDetailController(),
    permanent: true,
  );


  @override
  void initState() {

    super.initState();
  }


  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _controller.getHomeDetail(),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: SizeConfig().width,
                child: Obx(
                  () => _controller.isLoading.value
                      ? SizedBox.shrink()
                      : ListView.separated(
                          separatorBuilder: (_, index) => SizedBox(width: 5),
                          scrollDirection: Axis.horizontal,
                          itemCount: _controller.homeDetail.value.slider.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, index) => InkWell(
                            onTap: () {
                              final String type = _controller
                                  .homeDetail
                                  .value
                                  .slider[index]
                                  .sliderType;
                              String value =
                                  '${_controller.homeDetail.value.slider[index].value}';
                              print(type);
                              if (type == 'event') {
                                int t = _controller.homeDetail.value.events
                                    .indexWhere(
                                      (e) =>
                                          e.eventId ==
                                          (int.tryParse(value) ?? 0),
                                    );
                                if (t >= 0) {
                                  navigate(
                                    context: context,
                                    replace: false,
                                    path: detailRoute,
                                    param: {'showAppbar': false, 'index': t},
                                  );
                                }
                              } else if (type == 'virtual darshan') {
                                navigate(
                                  context: context,
                                  replace: false,
                                  path: virtualDarshanRoute,
                                );
                              } else if (type == 'post') {
                                jumpPage.sink.add(
                                  PageJumpDetail(
                                    page: 'ફીડ',
                                    additionalData: value,
                                  ),
                                );
                              } else if (type == 'Notification') {
                              } else if (type == 'externalLink') {
                                Helper.launch(url: value);
                              } else if (type == 'liveArti') {
                                navigate(
                                  context: context,
                                  replace: false,
                                  path:
                                      value.startsWith(
                                        'https://www.youtube.com',
                                      )
                                      ? youtubeVideoRoute
                                      : videoRoute,
                                  param: value,
                                );
                              }
                            },
                            child: RoundedImage(
                              fit: .cover,
                              url: _controller
                                  .homeDetail
                                  .value
                                  .slider[index]
                                  .sliderImage,
                              height: 200,
                              width: SizeConfig().width - 20,
                            ),
                          ),
                        ),
                ),
              ),
              10.h,
              Center(
                child: Row(
                  mainAxisSize: .min,
                  children: List.generate(
                    _controller.homeDetail.value.slider.length,
                    (index) {
                      return Container(
                        height: 8,
                        width: 8,
                        margin: .only(right: 5),
                        decoration: BoxDecoration(
                          color: CustomColors().grey500,
                          shape: .circle,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              10.h,
              Obx(
                () => _controller.isLoading.value == true
                    ? SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                          color: CustomColors().primaryColorDark,
                        ),
                        width: SizeConfig().width,
                        height: 30,
                        alignment: .center,
                        padding: .symmetric(vertical: 4),
                        child: MarqueeText(
                          widget: Text(
                            maxLines: 1,
                            _controller.homeDetail.value.impMsg,
                            style: semiBold(
                              fontSize: 14,
                              color: CustomColors().white,
                            ),
                          ),
                        ),
                      ),
              ),
              10.h,
              _features(),
              10.h,
              _live(),
              10.h,
              _festivals(),
              50.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _features() {
    final List<Map<String, dynamic>> list = [
      {
        "title": "બગદાણા ધામ",
        'image': "assets/images/ic_bagdana.svg",
        'navigate': menuDetailRoute,
        'color': CustomColors().deepPurple50,
      },
      {
        "title": "મંદિર",
        'image': "assets/images/ic_temple_clr.svg",
        'navigate': menuDetailRoute,
        'color': CustomColors().pink50,
      },
      {
        "title": "સુવિધા",
        'image': "assets/images/ic_service_clr.svg",
        'navigate': menuDetailRoute,
        'color': CustomColors().orange50,
      },
      {
        "title": "પ્રસંગ",
        'image': "assets/images/ic_event_clr.svg",
        'navigate': eventsRoute,
        'color': CustomColors().red50,
      },
      {
        "title": "પૂનમ લિસ્ટ",
        'image': "assets/images/ic_poonam_clr.svg",
        'navigate': punamListRoute,
        'color': CustomColors().teal50,
      },
      {
        "title": "ગેલેરી",
        'image': "assets/images/ic_gallery_clr.svg",
        'navigate': galleryRoute,
        'color': CustomColors().brown50,
      },
      {
        "title": "ડોનેશન",
        'image': "assets/images/ic_donation_clr.svg",
        'navigate': donationRoute,
        'color': CustomColors().blue50,
      },
      {
        "title": "આરતી",
        'image': "assets/images/ic_aarti_clr.svg",
        'navigate': aartiRoute,
        'color': CustomColors().yellow50,
      },
    ];

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          maxLines: 1,
          'Features',
          style: bolder(fontSize: 20, color: CustomColors().black),
        ),
        10.h,
        Wrap(
          spacing: 5,
          runSpacing: 10,
          children: list.map((e) {
            return InkWell(
              onTap: () async {
                if (e['navigate'] == donationRoute) {
                  jumpPage.sink.add(
                    PageJumpDetail(page: donationRoute, additionalData: ''),
                  );
                } else if (e['navigate'] == punamListRoute) {
                  jumpPage.sink.add(
                    PageJumpDetail(page: punamListRoute, additionalData: ''),
                  );
                } else if (e['navigate'] == eventsRoute) {
                  navigate(context: context, replace: false, path: eventsRoute);
                } else if (e['navigate'] == galleryRoute) {
                  navigate(
                    context: context,
                    replace: false,
                    path: galleryRoute,
                  );
                } else if (e['navigate'] == aartiRoute) {
                  navigate(
                    context: context,
                    replace: false,
                    path: aartiRoute,
                    param: _controller.homeDetail.value.arti,
                  );
                } else {
                  await _controller.getMenuDetail(menu: e['title']).then((
                    data,
                  ) {
                    if (data.isNotEmpty) {
                      navigate(
                        context: context,
                        replace: false,
                        path: e['navigate'],
                        param: {'title': e['title'], 'data': data},
                      );
                    }
                  });
                }
              },
              child: Container(
                padding: .all(10),
                alignment: .center,
                width: (SizeConfig().width / 4) - 10,
                decoration: BoxDecoration(
                  color: e['color'],
                  borderRadius: .circular(10),
                ),
                child: Column(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  children: [
                    ImageWidget(url: e['image'], height: 50, width: 50),
                    10.h,
                    Text(
                      maxLines: 1,
                      e['title'],
                      style: bolder(fontSize: 12, color: CustomColors().black),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _live() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          maxLines: 1,
          'Live Darshan',
          style: bolder(fontSize: 20, color: CustomColors().black),
        ),
        10.h,
        Stack(
          children: [
            InkWell(
              onTap: () {
                if (_controller.homeDetail.value.liveArti.isNotEmpty &&
                    Uri.tryParse(_controller.homeDetail.value.liveArti) !=
                        null) {
                  navigate(
                    context: context,
                    replace: false,
                    path:
                        _controller.homeDetail.value.liveArti.startsWith(
                          'https://www.youtube.com',
                        )
                        ? youtubeVideoRoute
                        : youtubeVideoRoute,
                    param: _controller.homeDetail.value.liveArti,
                  );
                }
              },
              child: RoundedImage(
                url: 'assets/images/live_arti_btn.png',
                height: 80,
                width: SizeConfig().width,
              ),
            ),
            Positioned(
              top: 10,
              right: 0,
              child: LottieBuilder.asset(
                'assets/animation/live_anim.json',
                height: 80,
              ),
            ),
          ],
        ),
        10.h,
        Stack(
          children: [
            InkWell(
              onTap: () {
                navigate(
                  context: context,
                  replace: false,
                  path: virtualDarshanRoute,
                );
              },
              child: Stack(
                children: [
                  RoundedImage(
                    url: 'assets/images/virtual_btn.png',
                    height: 80,
                    width: SizeConfig().width,
                  ),
                  Positioned(
                    top: 0,
                    left: Platform.isIOS ? 80 : 60,
                    child: LottieBuilder.asset(
                      'assets/animation/diya.json',
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        10.h,
      ],
    );
  }

  Widget _festivals() {
    return SizedBox(
      height: 250,
      width: SizeConfig().width,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [
              Text(
                maxLines: 1,
                'Temple Events & Festival',
                style: bolder(fontSize: 20, color: CustomColors().black),
              ),
              InkWell(
                onTap: () {
                  navigate(context: context, replace: false, path: eventsRoute);
                },
                child: Text(
                  maxLines: 1,
                  'View All',
                  style: bolder(fontSize: 12, color: CustomColors().grey500),
                ),
              ),
            ],
          ),
          10.h,
          Expanded(
            child: Obx(
              () => ListView.separated(
                scrollDirection: .horizontal,
                itemCount: _controller.homeDetail.value.events.length,
                shrinkWrap: true,
                separatorBuilder: (_, index) => SizedBox(width: 10),
                itemBuilder: (_, index) {
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
                          height: double.infinity,
                          fit: .cover,
                          url: _controller
                              .homeDetail
                              .value
                              .events[index]
                              .eventImage,
                          width: SizeConfig().width - 20,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            _controller
                                .homeDetail
                                .value
                                .events[index]
                                .eventTitle,
                            style: bolder(
                              fontSize: 14,
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
          ),
        ],
      ),
    );
  }
}
