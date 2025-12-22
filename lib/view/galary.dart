import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/custom_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/api_constant.dart';
import '../services/loger_service.dart';
import '../utils/size_config.dart';
import '../widget/image_widget.dart';
import '../widget/shimmer.dart';

class GalleryList extends StatefulWidget {
  const GalleryList({super.key});

  @override
  State<GalleryList> createState() => _GalleryListState();
}

class _GalleryListState extends State<GalleryList> {
  Rx<int> currentState = 0.obs;

  final ScrollController tabScrollController = ScrollController();
  final ScrollController scrollController = ScrollController();
  final PageController _pageController = PageController();
  Rx<bool> isLoading = false.obs;
  int currentOffset = 0;
  RxList<dynamic> list = RxList();

  Future<List<dynamic>> getDetail() async {
    try {
      final apiInstance = NetworkServiceMobile();
      await apiInstance.get(url: APIConstant().apiGallery).then((data) {
        if (data.isNotEmpty) {
          if (data['httpStatusCode'] == 200) {
            list.value = data['data'];
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    getDetail();
    tabScrollController.addListener(() {
      currentOffset = tabScrollController.offset.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'ગેલેરી',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SizedBox(
          height: SizeConfig().height,
          width: SizeConfig().width,
          //padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: Obx(
            () => isLoading.value
                ? ShimmerDemo()
                : Stack(
                    children: [
                      Container(
                        height: SizeConfig().height - 60,
                        width: SizeConfig().width,
                        padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                        child: Obx(
                          () => PageView.builder(
                            itemCount: list.length,
                            reverse: false,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            controller: _pageController,
                            itemBuilder: (_, index) {
                              final List<String> img = (list[index]['gallery'] as List).map((e) {
                                return e['image'] as String;
                              }).toList();
                              return _getImages(images: img);
                            },
                            onPageChanged: (index) {
                              if (index > currentState.value) {
                                tabScrollController.animateTo(currentOffset + 100, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
                              } else if (index < currentState.value) {
                                tabScrollController.animateTo(currentOffset - 100, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
                              }
                              currentState.value = index;
                              currentState.refresh();
                            },
                          ),
                        ),
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
                              if (index > currentState.value) {
                                tabScrollController.animateTo(currentOffset + 100, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
                              } else if (index < currentState.value) {
                                tabScrollController.animateTo(currentOffset - 100, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
                              }
                              currentState.value = index;
                              _pageController.jumpToPage(index);
                            },
                            tabs: list.map((e) {
                              return e['category_name'] as String;
                            }).toList(),
                            currentIndex: currentState.value,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _getImages({required List<String> images}) {
    return SizedBox(
      width: (SizeConfig().width - 50),
      child: 1 > 0
          ? GridView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 10, childAspectRatio: 1),
              itemCount: images.length,
              itemBuilder: (_, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      navigate(context: context, replace: false, path: imageRoute, param: {'image': images[index], 'showDownloadIcon': true});
                    },
                    child: ImageWidget(url: images[index], height: 150, fit: .cover),
                  ),
                );
              },
            )
          : Wrap(
              runSpacing: 10,
              spacing: 10,
              children: images.map((e) {
                return SizedBox(
                  width: (SizeConfig().width - 50) / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: () {
                        navigate(context: context, replace: false, path: imageRoute, param: e);
                      },
                      child: ImageWidget(url: e, height: 150, fit: .cover),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
