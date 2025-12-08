import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/widget/custom_tabs.dart';
import 'package:bapa_sitaram/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../constants/api_constant.dart';
import '../extensions/size_box_extension.dart';
import '../services/loger_service.dart';
import '../utils/size_config.dart';
import '../widget/image_widget.dart';
import '../widget/rounded_image.dart';



class TempleDetail extends StatefulWidget {
  const TempleDetail({super.key});
  @override
  State<TempleDetail> createState() => _TempleDetailState();
}

class _TempleDetailState extends State<TempleDetail> {
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

  Future<List<dynamic>> getMenuDetail({required String menu})async{
    List<dynamic> data=[];
    try{

      await NetworkServiceMobile().post(url: APIConstant().apiMenu,isFormData: false,requestBody: {
        'main_menu_name':'મંદિર'
      }).then((resp){

        if(resp.isNotEmpty){
          if(resp['httpStatusCode']==200){
            data=resp['data'];
          }
        }
      });
    }catch(e){
      LoggerService().log(message: e.toString());
    }
    return data;
  }


  @override
  Widget build(BuildContext context) {
    return _getBody();

  }

  Widget _getBody() {
    return Container(
      height: SizeConfig().height,
      width: SizeConfig().width,
      padding: .symmetric(horizontal: 10),
      child: FutureBuilder(future: getMenuDetail(menu: 'મંદિર'), builder: (_,snapshot){

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerDemo();
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          final list=snapshot.data??[];
          return Stack(
            children: [
              PageView.builder(
                itemCount: list.length,
                reverse: false,
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemBuilder: (_, index) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        60.h,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Obx(
                                    () => RoundedImage(
                                  url:
                                  list[currentTabIndex
                                      .value]['details']['image'],
                                ),
                              ),
                              16.h,

                              Obx(
                                    () => Text(
                                      list[currentTabIndex
                                      .value]['details']['title'],
                                  style: bolder(
                                    fontSize: 18,
                                    color: CustomColors().black,
                                  ),
                                ),
                              ),
                              10.h,
                              ImageWidget(
                                url: 'assets/images/flag_deco.png',
                                height: 60,
                              ),
                            ],
                          ),
                        ),
                        Obx(
                              () => Html(
                            data:
                            list[currentTabIndex
                                .value]['details']['description'],
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
                      ],
                    ),
                  );
                },
                onPageChanged: (index) {
                  if (index > currentTabIndex.value) {
                    tabScrollController.animateTo(
                      currentOffset + 100,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                    );
                  } else if (index < currentTabIndex.value) {
                    tabScrollController.animateTo(
                      currentOffset - 100,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                    );
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
                        tabScrollController.animateTo(
                          currentOffset + 100,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOut,
                        );
                      } else if (index < currentTabIndex.value) {
                        tabScrollController.animateTo(
                          currentOffset - 100,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOut,
                        );
                      }
                      currentTabIndex.value = index;
                      _pageController.jumpToPage(index);
                    },
                    tabs: list.map((e) {
                      return e['main_menu'] as String;
                    }).toList(),
                    currentIndex: currentTabIndex.value,
                  ),
                ),
              ),
            ],
          );
        }
      })
    );
  }
}

