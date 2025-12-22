import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({super.key, required this.onTap, required this.title, this.fullWidth = true, this.color, this.width, this.fontSize = 18});
  final VoidCallback onTap;
  final String title;
  final bool fullWidth;
  final Color? color;
  final double? width;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        width: width ?? SizeConfig().width,
        decoration: BoxDecoration(color: color ?? CustomColors().primaryColorDark, borderRadius: BorderRadius.circular(5)),
        padding: .symmetric(horizontal: 10, vertical: 8),
        child: Text(
          title,
          style: semiBold(fontSize: fontSize, color: CustomColors().white),
        ),
      ),
    );
  }
}
