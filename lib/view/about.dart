import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/controllers/home_controller.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/helper.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../extensions/size_box_extension.dart';
import '../utils/size_config.dart';
import '../widget/image_widget.dart';

class AboutUs extends StatelessWidget {
   AboutUs({super.key});
final HomeDetailController controller=Get.find<HomeDetailController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'અમારા વિશે', showDrawerIcon: false, onBackTap: (){
        Navigator.pop(context);
      }),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
        children: [
          ImageWidget(url: controller.aboutUs['about_image'],height: 250,width: SizeConfig().width,),
          20.h,
          Text(controller.aboutUs['about_title'],style: bolder(
            fontSize: 20,color: CustomColors().primaryColorDark
          ),),
          10.h,
          Text(controller.aboutUs['address'],style: bolder(
              fontSize: 14,color: CustomColors().grey500
          ),),
          10.h,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ImageWidget(height: 24,width: 24,url: 'assets/images/ic_email.svg'),
                  5.w,
                  Text(controller.aboutUs['about_email'],style: bolder(
                      fontSize: 14,color: CustomColors().grey500
                  ),),
                ],
              ),
              10.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ImageWidget(height: 24,width: 24,url: 'assets/images/ic_phone.svg'),
                  5.w,
                  Text(controller.aboutUs['about_phone'],style: bolder(
                      fontSize: 14,color: CustomColors().grey500
                  ),),
                ],
              ),
              10.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: (){
                        Helper.launch(url: controller.appSetting.aboutUs.facebook);
                      },
                      child: ImageWidget(height: 30,width: 30,url: 'assets/images/facebook.png')),
                  20.w,
                  InkWell(
                      onTap: (){
                        Helper.launch(url: controller.appSetting.aboutUs.instagram);
                      },

                      child: ImageWidget(height: 40,width: 40,url: 'assets/images/instagram.jpg')),
                  20.w,
                  InkWell(
                      onTap: (){
                        Helper.launch(url: controller.appSetting.aboutUs.twitter);
                      },

                      child: ImageWidget(height: 30,width: 30,url: 'assets/images/twitter.png')),
                  20.w,
                  InkWell(
                      onTap: (){
                        Helper.launch(url: controller.appSetting.aboutUs.youtube);
                      },
                      child: ImageWidget(height: 30,width: 30,url: 'assets/images/social.png')),
                  20.w,
                  InkWell(
                      onTap: (){
                        Helper.launch(url: controller.appSetting.aboutUs.aboutWebsite);
                      },
                      child: ImageWidget(height: 24,width: 24,url: 'assets/images/globe.png')),
                ],
              ),
              20.h,
              Center(
                child: Text('© 2026 All Rights Reserved & Managed by',style: bolder(
                    fontSize: 16,color: CustomColors().grey500
                ),)),
                Center(
                child: Text('Shree Guru Ashram - Bagdana',style: bolder(
                    fontSize: 16,color: CustomColors().black
                ),),
              ),Center(
                child:
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Design & Developed by Team - ',
                        style: bolder(fontSize: 16, color: CustomColors().grey500),
                      ),
                      TextSpan(
                        text: controller.appSetting.aboutUs.developBy,
                        style: bolder(fontSize: 16, color: CustomColors().blue700),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
            ],
          )
        ],
        ),
      )),
    );
  }
}
