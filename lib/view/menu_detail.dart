import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/custom_tabs.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:bapa_sitaram/widget/custom_html_widget.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({required this.title, required this.detail, super.key});

  final String title;
  final List<dynamic> detail;

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final ScrollController _scrollController = ScrollController();
  int currentOffset = 0;
  final ScrollController tabScrollController = ScrollController();
  final PageController _pageController = PageController();
  Rx<int> currentTabIndex = 0.obs;

  @override
  void initState() {    
    super.initState();
    _scrollController.addListener(() {
      currentOffset = _scrollController.offset.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.title,
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(child: _getBody()),
    );
  }

  Widget _getBody() {
    return Container(
      height: SizeConfig().height,
      width: SizeConfig().width,
      padding: const .symmetric(horizontal: 10),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.detail.length,
            reverse: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemBuilder: (_, index) {
              return Column(
                mainAxisSize: .min,
                crossAxisAlignment: .center,
                children: [
                  60.h,
                  /*  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Obx(
                          () => RoundedImage(
                            height: 250,
                            width: SizeConfig().width,
                            fit: .fitWidth,
                            url:
                                widget.detail[currentTabIndex
                                    .value]['details']['image'],
                          ),
                        ),
                        16.h,
              
                        Obx(
                          () => Text(
                            widget.detail[currentTabIndex
                                .value]['details']['title'],
                            style: bolder(
                              fontSize: 18,
                              color: CustomColors().black,
                            ),
                          ),
                        ),
                     10.h,

                     /*   ImageWidget(
                          url: 'assets/images/flag_deco.png',
                          height: 60,
                        ),*/
                      ],
                    ),
                  ),*/
                  Expanded(
                    child: Obx(
                      () => CustomHtmlWidget(content: widget.detail[currentTabIndex.value]['details']['description'], title: widget.detail[currentTabIndex.value]['details']['title'], image: widget.detail[currentTabIndex.value]['details']['image']),
                    ),
                  ),
                ],
              );
            },
            onPageChanged: (index) {
              if (index > currentTabIndex.value) {
                tabScrollController.animateTo(currentOffset + 100, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
              } else if (index < currentTabIndex.value) {
                tabScrollController.animateTo(currentOffset - 100, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
              }
              currentTabIndex.value = index;
              currentTabIndex.refresh();
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => CustomTabs(
                scrollController: tabScrollController,
                onTap: (index) {
                  //scrollController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
                  if (index > currentTabIndex.value) {
                    tabScrollController.animateTo(currentOffset + 100, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
                  } else if (index < currentTabIndex.value) {
                    tabScrollController.animateTo(currentOffset - 100, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
                  }
                  currentTabIndex.value = index;
                  _pageController.jumpToPage(index);
                },
                tabs: widget.detail.map((e) {
                  return e['main_menu'] as String;
                }).toList(),
                currentIndex: currentTabIndex.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
