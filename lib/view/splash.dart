import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/controllers/splash_controller.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/services/loger_service.dart';

import 'package:bapa_sitaram/widget/image_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool isLoggedIn = false;
  final SplashController _controller = Get.put(SplashController());
  late AnimationController _animationController;
  late AnimationController _animationController2;

  late Animation<double> _scale;
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController3 = ScrollController();
  final ScrollController _scrollController4 = ScrollController();
  final ScrollController _scrollController5 = ScrollController();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // rotation speed
    )..repeat();
    _animationController2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scale = Tween<double>(begin: 0.0, end: 1).animate(CurvedAnimation(parent: _animationController2, curve: Curves.easeIn));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScroll();
      _startLeftRoRight();
      _startScroll3();
      _startLeftRoRight4();
      _startLeftRoRight5();
      _controller.getData().then((data) {
        HelperService().playSound(sound: 'assets/sound/bapa_sitaram.mp3');
        Future.delayed(const Duration(seconds: 3)).then((y) {
          if (data.$1 == true) {
            if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsRegistered) == true && PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn) == false) {
              navigate(context: context, replace: true, path: loginRoute, param: _controller.detail.value);
            } else {
              navigate(context: context, replace: true, path: homeRoute, param: _controller.detail.value);
            }
          } else {
            navigate(context: context, replace: true, path: homeRoute, param: _controller.detail.value);
          }
        });
      });
    });
    super.initState();
    _animationController2.forward();
  }

  Future<void> _startScroll() async {
    try {
      // loop while widget is mounted; awaiting prevents scheduling unlimited futures
      while (mounted) {
        // small pause before each scroll cycle
        //  await Future.delayed(const Duration(milliseconds: 1500));

        if (!_scrollController1.hasClients) {
          // wait a bit for layout to attach the controller
          await Future.delayed(const Duration(milliseconds: 200));
          continue;
        }

        final maxExtent = _scrollController1.position.maxScrollExtent;
        if (maxExtent <= 0) {
          // nothing to scroll yet; try again later
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }

        // scroll from start to end (await so next loop iteration won't start early)
        await _scrollController1.animateTo(maxExtent, duration: const Duration(seconds: 60), curve: Curves.linear);

        // optional: brief pause, then return to start smoothly
        await Future.delayed(const Duration(milliseconds: 500));
        if (!_scrollController1.hasClients) break;
        await _scrollController1.animateTo(0.0, duration: const Duration(milliseconds: 600), curve: Curves.easeOut);
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> _startScroll3() async {
    try {
      // loop while widget is mounted; awaiting prevents scheduling unlimited futures
      while (mounted) {
        // small pause before each scroll cycle
        //    await Future.delayed(const Duration(milliseconds: 1500));

        if (!_scrollController3.hasClients) {
          // wait a bit for layout to attach the controller
          await Future.delayed(const Duration(milliseconds: 200));
          continue;
        }

        final maxExtent = _scrollController3.position.maxScrollExtent;
        if (maxExtent <= 0) {
          // nothing to scroll yet; try again later
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }

        // scroll from start to end (await so next loop iteration won't start early)
        await _scrollController3.animateTo(maxExtent, duration: const Duration(seconds: 60), curve: Curves.linear);

        // optional: brief pause, then return to start smoothly
        await Future.delayed(const Duration(milliseconds: 500));
        if (!_scrollController3.hasClients) break;
        await _scrollController3.animateTo(0.0, duration: const Duration(milliseconds: 600), curve: Curves.easeOut);
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> _startLeftRoRight() async {
    try {
      while (mounted) {
        //await Future.delayed(const Duration(milliseconds: 1500));

        if (!_scrollController2.hasClients) {
          await Future.delayed(const Duration(milliseconds: 200));
          continue;
        }

        final maxExtent = _scrollController2.position.maxScrollExtent;
        if (maxExtent <= 0) {
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }

        /// FIRST → go LEFT (0.0)
        await _scrollController2.animateTo(0.0, duration: const Duration(seconds: 60), curve: Curves.linear);

        /// Then pause
        await Future.delayed(const Duration(milliseconds: 500));
        if (!_scrollController2.hasClients) break;

        /// SECOND → go RIGHT (maxExtent)
        await _scrollController2.animateTo(maxExtent, duration: const Duration(milliseconds: 600), curve: Curves.easeOut);
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> _startLeftRoRight4() async {
    try {
      while (mounted) {
        //    await Future.delayed(const Duration(milliseconds: 1500));

        if (!_scrollController4.hasClients) {
          await Future.delayed(const Duration(milliseconds: 200));
          continue;
        }

        final maxExtent = _scrollController4.position.maxScrollExtent;
        if (maxExtent <= 0) {
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }

        /// FIRST → go LEFT (0.0)
        await _scrollController4.animateTo(0.0, duration: const Duration(seconds: 60), curve: Curves.linear);

        /// Then pause
        await Future.delayed(const Duration(milliseconds: 500));
        if (!_scrollController4.hasClients) break;

        /// SECOND → go RIGHT (maxExtent)
        await _scrollController4.animateTo(maxExtent, duration: const Duration(milliseconds: 600), curve: Curves.easeOut);
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> _startLeftRoRight5() async {
    try {
      while (mounted) {
        //    await Future.delayed(const Duration(milliseconds: 1500));

        if (!_scrollController5.hasClients) {
          await Future.delayed(const Duration(milliseconds: 200));
          continue;
        }

        final maxExtent = _scrollController5.position.maxScrollExtent;
        if (maxExtent <= 0) {
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }

        /// FIRST → go LEFT (0.0)
        await _scrollController5.animateTo(0.0, duration: const Duration(seconds: 60), curve: Curves.linear);

        /// Then pause
        await Future.delayed(const Duration(milliseconds: 500));
        if (!_scrollController5.hasClients) break;

        /// SECOND → go RIGHT (maxExtent)
        await _scrollController5.animateTo(maxExtent, duration: const Duration(milliseconds: 600), curve: Curves.easeOut);
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    _scrollController1.dispose();
    _scrollController2.dispose();
    _scrollController3.dispose();
    _scrollController4.dispose();
    _scrollController5.dispose();
    Get.delete<SplashController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _mobile(context: context);
  }

  Widget _mobile({required BuildContext context}) {
    return Scaffold(
      body: SafeArea(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            CustomColors().primaryColorDark.withOpacity(0.7),
            // light reddish tint
            BlendMode.luminosity, // preserves brightness
          ),
          child: Stack(
            children: [
              Image.asset('assets/images/ic_splash_bg.png', height: SizeConfig().height, width: SizeConfig().width, fit: .cover),
              Positioned(
                top: (SizeConfig().height / 2) - 140,
                left: 0,
                child: Center(
                  child: Container(
                    height: 200,
                    width: SizeConfig().width,
                    alignment: .center,
                    child: Stack(
                      children: [
                        Container(
                          padding: const .symmetric(vertical: 30),
                          height: 200,
                          width: SizeConfig().width,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(CustomColors().black1000.withOpacity(0.2), BlendMode.dstATop),
                            child: getImageBox(controller: _scrollController5),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: (SizeConfig().width / 2) - 90,
                          child: Center(
                            child: Stack(
                              children: [
                                AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (_, child) {
                                    return Transform.rotate(
                                      angle: _animationController.value * 2 * 3.1415926, // clockwise rotation
                                      child: child,
                                    );
                                  },
                                  child: const ImageWidget(url: 'assets/images/ic_back_circle.png', height: 150, width: 150, fit: .cover),
                                ),
                                Positioned(
                                  top: 15,
                                  left: 15,
                                  child: 1 > 0
                                      ? ScaleTransition(
                                          scale: _scale,
                                          child: Container(
                                            height: 120,
                                            width: 120,
                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                            child: const ImageWidget(url: 'assets/images/asram_logo.png'),
                                          ),
                                        )
                                      : Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                                          child: const ImageWidget(url: 'assets/images/asram_logo.png'),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                child: Column(
                  children: [
                    getImageBox(controller: _scrollController1),
                    getImageBox(controller: _scrollController2),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                child: Column(
                  children: [
                    getImageBox(controller: _scrollController3),
                    getImageBox(controller: _scrollController4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageBox({required ScrollController controller}) {
    return SizedBox(
      height: 130,
      width: SizeConfig().width,
      child: ListView(
        padding: .zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ImageWidget(url: 'assets/images/ic_splash_clip.png', width: SizeConfig().width),
          ImageWidget(url: 'assets/images/ic_splash_clip.png', width: SizeConfig().width),
          ImageWidget(url: 'assets/images/ic_splash_clip.png', width: SizeConfig().width),
          ImageWidget(url: 'assets/images/ic_splash_clip.png', width: SizeConfig().width),
        ],
      ),
    );
  }
}
