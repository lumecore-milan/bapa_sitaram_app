import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';

import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:bapa_sitaram/widget/image_widget.dart';

final class BottomList {
  BottomList({required this.image, required this.title});

  final String image, title;
}

class BottomBar extends StatelessWidget {
  BottomBar({required this.onTap, required this.currentIndex, super.key});

  final Function(int) onTap;
  final int currentIndex;
  final List<BottomList> _bottomList = [
    BottomList(image: 'assets/images/home.svg', title: 'હોમ'),
    BottomList(image: 'assets/images/ic_temple.svg', title: 'મંદિર'),
    BottomList(image: 'assets/images/feed.svg', title: 'ફીડ'),
    BottomList(image: 'assets/images/ic_poonam_menu.svg', title: 'પૂનમ લિસ્ટ'),
    BottomList(image: 'assets/images/ic_contact.svg', title: 'સંપર્ક કરો'),

    //  BottomList(image: 'assets/images/ic_donation_menu.svg', title: 'ડોનેશન'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: SizeConfig().width,
      decoration: BoxDecoration(color: CustomColors().alWhite),
      padding: const .symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _bottomList.map((e) {
          return Container(
            width: (SizeConfig().width / _bottomList.length) - 10,
            alignment: .center,
            child: InkWell(
              onTap: () {
                onTap(_bottomList.indexOf(e));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    padding: const .only(top: 3, bottom: 3),
                    alignment: .center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: _bottomList.indexOf(e) == currentIndex ? CustomColors().deepPurple50 : null),
                    child: ImageWidget(url: e.image, width: 24, height: 24),
                  ),

                  const SizedBox(height: 5),
                  Text(e.title, style: bolder(fontSize: 10, color: _bottomList.indexOf(e) == currentIndex ? CustomColors().primaryColorDark : null)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
