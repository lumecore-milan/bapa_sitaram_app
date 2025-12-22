import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:flutter/material.dart';

const String fontFamilyVadodara = 'HindVadodara';
TextStyle bolder({double fontSize = 12, Color? color, String fontFamily = fontFamilyVadodara}) {
  return TextStyle(fontWeight: .w700, fontSize: fontSize, color: color ?? Colors.black, fontFamily: fontFamily);
}

TextStyle semiBold({double fontSize = 12, Color? color, String fontFamily = fontFamilyVadodara}) {
  return TextStyle(fontWeight: .w600, fontSize: fontSize, color: color ?? CustomColors().black1000, fontFamily: fontFamily);
}

TextStyle medium({double fontSize = 12, Color? color, String fontFamily = fontFamilyVadodara}) {
  return TextStyle(fontWeight: .w500, fontSize: fontSize, color: color ?? Colors.black, fontFamily: fontFamily);
}

TextStyle regular({double fontSize = 12, Color? color, String fontFamily = fontFamilyVadodara}) {
  return TextStyle(fontWeight: .w400, fontSize: fontSize, color: color ?? Colors.black, fontFamily: fontFamily);
}
