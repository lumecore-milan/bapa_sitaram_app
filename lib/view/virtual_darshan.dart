import 'dart:math';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../extensions/size_box_extension.dart';
import '../utils/size_config.dart';
import '../widget/image_widget.dart';

class VirtualDarshan extends StatefulWidget {
  const VirtualDarshan({super.key});

  @override
  State<VirtualDarshan> createState() => _VirtualDarshanState();
}

class _VirtualDarshanState extends State<VirtualDarshan>
    with TickerProviderStateMixin {
  late AnimationController _pushpaController;
  late AnimationController _diyaController;
  late AnimationController _shankhController;
  late AnimationController _aartiController;
  late AnimationController _thalController;
  late AnimationController _templeController;
  Rx<bool> isArtiRunning = false.obs;
  Rx<bool> isThalRunning = false.obs;
  Rx<bool> isTempleToggle=false.obs;

  Rx<bool> isTempleOpened=false.obs;

  late AnimationController _curtainController;
  late Animation<double> _leftCurtainAnim;
  late Animation<double> _rightCurtainAnim;

  @override
  void dispose() {
    _curtainController.dispose();
    _diyaController.dispose();
    _shankhController.dispose();
    _pushpaController.dispose();
    _aartiController.dispose();
    _thalController.dispose();
    _templeController.dispose();


    super.dispose();
  }

  late Animation<Offset> _moveAnimation;
  @override
  void initState() {
    _shankhController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );_diyaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _pushpaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _thalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _templeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _aartiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _curtainController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _leftCurtainAnim = Tween<double>(begin: 0, end: -1).animate(
      CurvedAnimation(parent: _curtainController, curve: Curves.easeInOut),
    );

    // Right curtain moves to right (+width)
    _rightCurtainAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _curtainController, curve: Curves.easeInOut),
    );

    _aartiController.repeat(); // continuously orbit
    _thalController.stop();
    _pushpaController.stop();
    _aartiController.stop();
    _thalController.stop();
    _templeController.stop();
    _diyaController.stop();

    super.initState();


    _thalController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _moveAnimation = Tween<Offset>(
      begin: Offset(0, 1.5),   // Bottom outside screen
      end: Offset(0, 0),       // Middle (stay here)
    ).animate(CurvedAnimation(
      parent: _thalController,
      curve: Curves.easeOutBack,
    ));

    HelperService().initSoundSources(
       soundFiles: ['assets/sound/shankh_audio.mp3']
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Virtual Darshan', showDrawerIcon: false,onBackTap: () { Navigator.pop(context); },),
      body: SafeArea(
        child: SizedBox(
          height: SizeConfig().height,
          width: SizeConfig().width,
          child: Obx(()=>isTempleOpened.value==false ? openTempleView():
             Stack(
              fit: .expand,
              children: [
                Obx(()=> ImageWidget(url:isTempleToggle.value==false ? 'assets/images/main_img_1.png':'assets/images/main_img_3.png', fit: .cover)),
                Positioned(
                  top: 0,
                  left: 0,
                  child: ImageWidget(
                    url: 'assets/images/top1.png',
                    fit: .fill,
                    height: 240,
                    width: SizeConfig().width,
                  ),
                ),
                Positioned(
                  top: 220,
                  left: 20,
                  child: ImageWidget(
                    url: 'assets/images/flower_deco2.png',
                    fit: .fitHeight,
                    height: 150,
                    width: 30,
                  ),
                ),
                Positioned(
                  top: 220,
                  right: 20,
                  child: ImageWidget(
                    url: 'assets/images/flower_deco2.png',
                    fit: .fitHeight,
                    height: 150,
                    width: 30,
                  ),
                ),

                Positioned(
                  top: 180,
                  left: 0,
                  child: LottieBuilder.asset(
                    'assets/animation/leftBell.json',
                    height: 170,
                  ),
                ),
                Positioned(
                  top: 180,
                  right: 0,
                  child: LottieBuilder.asset(
                    'assets/animation/leftBell.json',
                    height: 170,
                  ),
                ),

                Positioned(
                  top: 130,
                  left: 0,
                  child: LottieBuilder.asset(
                    fit: .cover,
                    controller: _shankhController,
                    'assets/animation/flower_ry.json',
                    height: SizeConfig().height - 130,
                    width: 200,
                    onLoaded: (composition) {},
                  ),
                ),

                Obx(
                  () => isArtiRunning.value == false
                      ? SizedBox.shrink()
                      : Positioned(
                          top: (SizeConfig().height / 2) - 50,
                          left: (SizeConfig().width / 2) - 30,
                          child: AnimatedBuilder(
                            animation: _aartiController,
                            builder: (_, child) {
                              double angle = _aartiController.value * 2 * pi;
                              double radius = 70;
                              return Transform.translate(
                                offset: Offset(
                                  radius * cos(angle),
                                  radius * sin(angle),
                                ),
                                child: child,
                              );
                            },

                            child: ClipOval(
                              child: ImageWidget(
                                url: 'assets/images/arti_dish_1.png',
                                height: 100,
                                width: 100,
                                fit: .fill,
                              ),
                            ),
                          ),
                        ),
                ),

                Obx(()=> isThalRunning.value==false ? SizedBox.shrink():
                   Positioned(
                    bottom: SizeConfig().height * 0.25,
                    left: (SizeConfig().width/2)-100,
                    child: SlideTransition(
                      position: _moveAnimation,
                      child: Stack(
                        children: [
                          LottieBuilder.asset(
                            fit: .cover,
                            controller: _diyaController,
                            'assets/animation/diya.json',
                            height: 200,
                            width: 200,
                            onLoaded: (composition) {},
                          ),
                          Positioned(
                            top: 50,
                            left: 50,
                            child: RoundedImage(
                              url: 'assets/images/thal_dish.png',
                              height: 100,
                              width: 100,
                              fit: .fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 100,
                  left: 50,
                  child: LottieBuilder.asset(
                    fit: .cover,
                    controller: _pushpaController,
                    'assets/animation/flower_rw.json',
                    height: SizeConfig().height - 100,
                    width: 100,
                    onLoaded: (composition) {},
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  child: ImageWidget(
                    url: 'assets/images/bottom.png',
                    fit: .fitWidth,
                    height: 150,
                    width: SizeConfig().width,
                  ),
                ),
                tools(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tools() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () {
                    HelperService().playSound(sound: 'assets/sound/shankh_audio.mp3');
                    _shankhController
                      ..reset()
                      ..forward();

                  },
                  child: ImageWidget(
                    url: 'assets/images/btn_sankh.png',
                    height: 60,
                    width: 60,
                  ),
                ),
                5.h,
                Text(
                  'શંખનાદ',
                  style: semiBold(fontSize: 14, color: CustomColors().white),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    _pushpaController
                      ..reset()
                      ..forward();
                  },
                  child: ImageWidget(
                    url: 'assets/images/btn_flower.png',
                    height: 60,
                    width: 60,
                  ),
                ),
                5.h,
                Text(
                  'પુષ્પ',
                  style: semiBold(fontSize: 14, color: CustomColors().white),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    if(isThalRunning.value==true){
                      return;
                    }
                    isArtiRunning.toggle();
                    if (isArtiRunning.value == true) {
                      _aartiController.repeat();
                      _shankhController.repeat();
                      _pushpaController.repeat();
                    } else {
                      _aartiController.reset();
                      _aartiController.stop();

                      _shankhController.reset();
                      _shankhController.stop();
                      _pushpaController.reset();
                      _pushpaController.stop();
                    }
                  },
                  child: RoundedImage(
                    url: 'assets/images/arti_dish_1.png',
                    height: 60,
                    width: 60,
                    fit: .fill,
                  ),
                ),
                5.h,
                Text(
                  'આરતી',
                  style: semiBold(fontSize: 14, color: CustomColors().white),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    if(isArtiRunning.value==true){
                      return;
                    }

                    _thalController.reset();
                    _thalController.forward();
                    _diyaController.reset();
                    _diyaController.forward();
                    _diyaController.repeat();
                    isThalRunning.value=true;
                    Future.delayed(Duration(seconds: 6)).then((t){
                      _thalController.reverse().then((t){
                        isThalRunning.value=false;
                      });
                    });
                  },
                  child: ImageWidget(
                    url: 'assets/images/btn_thal.png',
                    height: 60,
                    width: 60,
                  ),
                ),
                5.h,
                Text(
                  'થાળ',
                  style: semiBold(fontSize: 14, color: CustomColors().white),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    isTempleToggle.toggle();
                  },

                  child: ImageWidget(
                    url: 'assets/images/btntemple.png',
                    height: 60,
                    width: 60,
                  ),
                ),
                5.h,
                Text(
                  'મંદિર',
                  style: semiBold(fontSize: 14, color: CustomColors().white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget openTempleView(){
    final double screenWidth=SizeConfig().width;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: screenWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// BG Row (Curtains)
          AnimatedBuilder(
            animation: _curtainController,
            builder: (_, child) {
              return Row(
                children: [
                  // LEFT CURTAIN
                  Transform.translate(
                    offset: Offset(_leftCurtainAnim.value * screenWidth, 0),
                    child: ImageWidget(
                      url: 'assets/images/left_curtain.png',
                      width: screenWidth / 2,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // RIGHT CURTAIN
                  Transform.translate(
                    offset: Offset(_rightCurtainAnim.value * screenWidth, 0),
                    child: ImageWidget(
                      url: 'assets/images/right_curtain.png',
                      width: screenWidth / 2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          ),

          /// OPEN BUTTON
          Center(
            child: InkWell(
              onTap: (){
                if (_curtainController.isCompleted) {
                  _curtainController.reverse().then((r){

                  });
                } else {
                  _curtainController.forward().then((t){
                    isTempleOpened.value=true;
                  });
                }
              },
              child: ImageWidget(
                url: 'assets/images/opne_curtain.png',
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
