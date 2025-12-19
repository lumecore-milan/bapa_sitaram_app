import 'dart:async';
import 'dart:io';
import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:bapa_sitaram/view/donation.dart';
import 'package:bapa_sitaram/view/punam_list.dart';
import 'package:bapa_sitaram/widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constant.dart';
import '../controllers/home_controller.dart';
import '../models/app_loading.dart';
import '../utils/custom_dialogs.dart';
import '../utils/events.dart';
import '../utils/route_generate.dart';
import '../utils/size_config.dart';
import '../widget/app_bar.dart';
import '../widget/bottom_bar.dart';
import '../widget/image_widget.dart';
import 'feeds.dart';
import 'home_detail.dart';
import 'mandir.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.detail});

  final AppSettingModel detail;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;
  late StreamSubscription<PageJumpDetail> _pageListener;

  Rx<bool> drawerOpen = false.obs;
  String detailId = '';

  @override
  void dispose() {
    _pageController.dispose();
    _pageListener.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _pageListener = jumpPage.stream.listen((route) {
      detailId = route.additionalData;
      if (route.page == donationRoute) {
        currentPageIndex.value = 4;
        appBarTitle.value = 'ડોનેશન';
        appBarTitle.refresh();
        _pageController.jumpToPage(4);
      } else if (route.page == punamListRoute) {
        currentPageIndex.value = 3;
        appBarTitle.value = 'પૂનમ લિસ્ટ';
        appBarTitle.refresh();
        currentPageIndex.refresh();
        _pageController.jumpToPage(3);
      } else if (route.page == homeRoute) {
        currentPageIndex.value = 0;
        appBarTitle.value = 'બાપા સીતારામ';
        appBarTitle.refresh();
        currentPageIndex.refresh();
        _pageController.jumpToPage(0);
      } else if (route.page == feedRoute) {
        currentPageIndex.value = 2;
        appBarTitle.value = 'ફીડ';
        appBarTitle.refresh();
        currentPageIndex.refresh();
        _pageController.jumpToPage(2);
      }
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeDetailController>().appSetting = widget.detail;

      Future.delayed(Duration(seconds: 4)).then((t) async {
        String appVersion=Platform.isAndroid ? AppConstants().androidAppVersion:AppConstants().iOSAppVersion;
        if(widget.detail.version.versionNo.isNotEmpty &&  appVersion!= widget.detail.version.versionNo){
          appUpdateDialog(context: context, title: widget.detail.version.versionTitle, message: widget.detail.version.versionMessage,forceUpdate: widget.detail.version.versionForceUpdate=='1');
        }
        /* final status=await PermissionService().requestNotificationPermission();
          if(status){
            String fcmToken=await FirebaseService().getFcmToken();
            if(fcmToken.isNotEmpty){
              LoggerService().log(message: 'Fcm token is $fcmToken');
            }
          }*/
      });
    });
  }

  RxString appBarTitle = "બાપા સીતારામ".obs;

  @override
  Widget build(BuildContext context) {
    return _mobile(context: context);
  }

  Widget _mobile({required BuildContext context}) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (status, result) {
        rateUsDialog(context: context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Obx(
                () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  left: drawerOpen.value ? 0 : -(SizeConfig().width * 0.70),
                  top: 0,
                  bottom: 0,
                  width: SizeConfig().width * 0.70,
                  child: CustomDrawer(
                    currentIndex: 0,
                    onTap: (path) {
                      drawerOpen.value = false;
                      if (path == loginRoute) {
                        final detail =
                            Get.find<HomeDetailController>().appSetting =
                                widget.detail;
                        if (ModalRoute.of(context)?.settings.name != null &&
                            ModalRoute.of(context)?.settings.name !=
                                homeRoute) {
                          Navigator.popUntil(context, (route) {
                            return route.settings.name == homeRoute;
                          });
                        }
                        PreferenceService().clear();
                        navigate(
                          context: context,
                          replace: true,
                          path: loginRoute,
                          param: detail,
                          removePreviousRoute: true,
                        );
                      } else if (path == homeRoute) {
                        if (ModalRoute.of(context)?.settings.name != null &&
                            ModalRoute.of(context)?.settings.name !=
                                homeRoute) {
                          Navigator.popUntil(context, (route) {
                            return route.settings.name == homeRoute;
                          });
                        }
                        jumpPage.sink.add(
                          PageJumpDetail(page: homeRoute, additionalData: ''),
                        );
                      } else if (path == punamListRoute) {
                        if (ModalRoute.of(context)?.settings.name != null &&
                            ModalRoute.of(context)?.settings.name !=
                                homeRoute) {
                          Navigator.popUntil(context, (route) {
                            return route.settings.name == homeRoute;
                          });
                        }
                        jumpPage.sink.add(
                          PageJumpDetail(
                            page: punamListRoute,
                            additionalData: '',
                          ),
                        );
                      } else if (path == donationRoute) {
                        if (ModalRoute.of(context)?.settings.name != null &&
                            ModalRoute.of(context)?.settings.name !=
                                homeRoute) {
                          Navigator.popUntil(context, (route) {
                            return route.settings.name == homeRoute;
                          });
                        }
                        jumpPage.sink.add(
                          PageJumpDetail(
                            page: donationRoute,
                            additionalData: '',
                          ),
                        );
                      } else if (path == aartiRoute) {
                        final HomeDetailController controller =
                            Get.find<HomeDetailController>();
                        navigate(
                          context: context,
                          replace: false,
                          path: aartiRoute,
                          param: controller.homeDetail.value.arti,
                        );
                      } else {
                        navigate(context: context, replace: false, path: path);
                      }
                    },
                  ),
                ),
              ),
              Obx(
                () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  left: drawerOpen.value ? (SizeConfig().width * 0.70) : 0,
                  top: drawerOpen.value ? 40 : 0,
                  bottom: drawerOpen.value ? 40 : 0,
                  width: drawerOpen.value
                      ? (SizeConfig().width * 0.30)
                      : SizeConfig().width,
                  child: _buildMainScaffold(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainScaffold() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => CustomAppbar(
            showDrawerIcon: !drawerOpen.value,
            title: appBarTitle.value,
            onBackTap: () {
              if (drawerOpen.value == true) {
                drawerOpen.value = false;
              }
            },
            onDrawerIconTap: () {
              drawerOpen.value = true;
            },
            actions: drawerOpen.value == true
                ? [SizedBox.shrink()]
                : [
                    InkWell(
                      onTap: () {
                        showDarshanTimeDialog(context: context);
                      },
                      child: ImageWidget(
                        url: 'assets/images/ic_calender.svg',
                        height: 24,
                        width: 24,
                        color: CustomColors().white,
                      ),
                    ),
                  ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Obx(
          () => BottomBar(
            currentIndex: currentPageIndex.value,
            onTap: (pageIndex) async {
              currentPageIndex.value = pageIndex;
              if (pageIndex == 0) {
                appBarTitle.value = 'બાપા સીતારામ';
              } else if (pageIndex == 1) {
                appBarTitle.value = 'મંદિર';
              } else if (pageIndex == 2) {
                appBarTitle.value = 'ફીડ';
              } else if (pageIndex == 3) {
                appBarTitle.value = 'પૂનમ લિસ્ટ';
              } else if (pageIndex == 4) {
                appBarTitle.value = 'ડોનેશન';
              }
              _pageController.jumpToPage(pageIndex);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: 5,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {},
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return HomeDetailPage();
            } else if (index == 1) {
              return TempleDetail();
            } else if (index == 2) {
              return FeedsPage(detailId: detailId);
            } else if (index == 3) {
              return PunamListPage();
            } else if (index == 4) {
              return DonationPage();
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
