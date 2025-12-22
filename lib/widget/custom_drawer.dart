import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../extensions/size_box_extension.dart';
import '../utils/size_config.dart';
import 'image_widget.dart';

final class DrawerItem {
  final String mainTitle;
  final List<Map<String, dynamic>> subItems;

  DrawerItem({required this.mainTitle, required this.subItems});
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.currentIndex, required this.onTap});

  final Function(String) onTap;
  final int currentIndex;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: SizeConfig().height,
        color: CustomColors().layoutPrimaryBackground,
        child: Stack(
          children: [
            Padding(
              padding: .only(left: 10, right: 10, top: 240),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _drawerItem(
                      menu: DrawerItem(
                        mainTitle: 'Main',
                        subItems: [
                          {'image': "assets/images/ic_home.svg", 'title': "હોમ", 'navigate': homeRoute},
                          {'image': "assets/images/ic_poonam_clr.svg", 'title': "પૂનમ લિસ્ટ", 'navigate': punamListRoute},
                          {'image': "assets/images/ic_aarti_clr.svg", 'title': "આરતી", 'navigate': aartiRoute},
                          {'image': "assets/images/ic_donation_clr.svg", 'title': "ડોનેશન", 'navigate': donationRoute},
                        ],
                      ),
                    ),

                    _drawerItem(
                      menu: DrawerItem(
                        mainTitle: 'Quick Link',
                        subItems: [
                          {'image': "assets/images/ic_press.svg", 'title': "પ્રેસ મીડિયા", 'navigate': pressRoute},
                          {'image': "assets/images/ic_social_act.svg", 'title': "સામાજિક પ્રવૃત્તિ", 'navigate': socialActivityRoute},
                          if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn) == true) {'image': "assets/images/ic_comment.svg", 'title': "My Donation", 'navigate': myDonationRoute},
                          {'image': "assets/images/ic_contact.svg", 'title': "સંપર્ક કરો", 'navigate': contactRoute},
                        ],
                      ),
                    ),
                    _drawerItem(
                      menu: DrawerItem(
                        mainTitle: 'User Info',
                        subItems: [
                          if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn) == true) {'image': "assets/images/profile.png", 'title': "પ્રોફાઈલ", 'navigate': userRegistrationRoute},
                          {'image': "assets/images/ic_download.svg", 'title': "ડાઉનલોડ પોસ્ટ", 'navigate': downloadPostRoute},
                          if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn) == false) {'image': "assets/images/logout.png", 'title': "Login Now", 'navigate': loginRoute},
                          if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn) == true) {'image': "assets/images/logout.png", 'title': "Logout", 'navigate': loginRoute},
                        ],
                      ),
                    ),
                    _drawerItem(
                      menu: DrawerItem(
                        mainTitle: 'Application',
                        subItems: [
                          {'image': "assets/images/ic_setting.svg", 'title': "સેટિંગ્સ", 'navigate': settingRoute},
                          {'image': "assets/images/info.png", 'title': "અમારા વિશે", 'navigate': aboutRoute},
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Stack(
                clipBehavior: Clip.none, // allow overflow
                children: [
                  // Top Image Container
                  Column(
                    children: [
                      Container(
                        height: 150,
                        width: SizeConfig().width * 0.70,
                        decoration: BoxDecoration(
                          color: CustomColors().white,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                        ),
                        child: Image.asset('assets/images/bg_image.jpeg', fit: BoxFit.cover, color: CustomColors().primaryColorDark..withOpacity(0.7), colorBlendMode: BlendMode.multiply),
                      ),
                      40.h,
                      Center(
                        child: Text('Bapa Sitaram', style: semiBold(fontSize: 22, color: CustomColors().black)),
                      ),
                      10.h,
                      Container(height: 1, width: (SizeConfig().width * 0.70), color: CustomColors().grey600),
                    ],
                  ),
                  Positioned(
                    top: 150 - 40, // half outside
                    left: ((SizeConfig().width * 0.70) / 2) - 40,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                      child: ImageWidget(url: 'assets/images/asram_logo.png'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({required DrawerItem menu}) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(menu.mainTitle, style: semiBold(fontSize: 16, color: CustomColors().grey600)),
        10.h,
        ListView.separated(
          shrinkWrap: true,
          padding: .zero,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (_, index) => 5.h,
          itemCount: menu.subItems.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                widget.onTap(menu.subItems[index]['navigate']);
              },
              child: Row(
                mainAxisSize: .min,
                mainAxisAlignment: .start,
                children: [
                  ImageWidget(url: menu.subItems[index]['image'], height: 24, width: 24, color: (menu.subItems[index]['title'] == 'હોમ' || menu.subItems[index]['title'] == 'ડાઉનલોડ પોસ્ટ') ? CustomColors().primaryColorDark : null),
                  10.w,
                  Text(menu.subItems[index]['title'], style: bolder(fontSize: 16, color: CustomColors().black)),
                ],
              ),
            );
          },
        ),
        10.h,
      ],
    );
  }
}
