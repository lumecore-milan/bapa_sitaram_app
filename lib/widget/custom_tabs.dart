import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';

class CustomTabs extends StatelessWidget {
  const CustomTabs({super.key, required this.tabs, required this.currentIndex, required this.onTap, required this.scrollController});

  final List<String> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 5),
      color: CustomColors().white1000,
      alignment: .centerLeft,
      height: 50,
      child: ListView.separated(
        controller: scrollController,
        itemCount: tabs.length,
        scrollDirection: .horizontal,
        shrinkWrap: true,
        separatorBuilder: (_, index) => SizedBox(width: 10),
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              onTap(index);
            },
            child: AnimatedContainer(
              alignment: .center,
              padding: .symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(color: index == currentIndex ? CustomColors().black : null, borderRadius: BorderRadius.circular(30)),
              duration: const Duration(milliseconds: 300),
              child: AnimatedDefaultTextStyle(
                style: bolder(fontSize: 14, color: index == currentIndex ? CustomColors().white : CustomColors().grey600),
                duration: const Duration(milliseconds: 300),
                child: Text(tabs[index], style: bolder(fontSize: 14, color: index == currentIndex ? CustomColors().white : CustomColors().grey600)),
              ),
            ),
          );
        },
      ),
    );
  }
}
