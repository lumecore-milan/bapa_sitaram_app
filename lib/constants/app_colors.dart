import 'package:flutter/material.dart';

class CustomColors {
  // Singleton pattern
  static final CustomColors _instance = CustomColors._internal();
  factory CustomColors() => _instance;
  CustomColors._internal();

  final Color primaryColor = const Color(0xFF8F0909);
  final Color primaryColorDark = const Color(0xFF660808);

  final Color black = const Color(0xFF000000);
  final Color white = const Color(0xFFFFFFFF);
  final Color alWhite = const Color(0xFFFFFFFF);

  final Color layoutPrimaryBackground = const Color(0xFFFAFAFA);
  final Color layoutSelection = const Color(0xFFBDBDBD);

  final Color alGrey800 = const Color(0xFF5D5D5D);

  final Color transparent = const Color(0x00000000);

  final Color overlayDark50 = const Color(0x80000000);
  final Color overlayLight30 = const Color(0x4DFFFFFF);

  final Color colorBackgroundBox = const Color(0xFFF5F5F5);
  final Color colorBackgroundBoxStroke = const Color(0xFFDEDEDE);
  final Color colorBackgroundBoxStrokeActive = const Color(0xFF1565C0); // blue_800

  // Grey
  final Color grey50 = const Color(0xFFFAFAFA);
  final Color grey100 = const Color(0xFFF5F5F5);
  final Color grey200 = const Color(0xFFEEEEEE);
  final Color grey300 = const Color(0xFFE0E0E0);
  final Color grey400 = const Color(0xFFBDBDBD);
  final Color grey500 = const Color(0xFF9E9E9E);
  final Color grey600 = const Color(0xFF757575);
  final Color grey700 = const Color(0xFF616161);
  final Color grey800 = const Color(0xFF424242);
  final Color grey900 = const Color(0xFF212121);
  final Color black1000 = const Color(0xFF000000);
  final Color white1000 = const Color(0xFFFFFFFF);
  final Color iconColor = const Color(0xFF969696);

  // Red
  final Color red50 = const Color(0xFFFFEBEE);
  final Color red100 = const Color(0xFFFFCDD2);
  final Color red200 = const Color(0xFFEF9A9A);
  final Color red300 = const Color(0xFFE57373);
  final Color red400 = const Color(0xFFEF5350);
  final Color red500 = const Color(0xFFF44336);
  final Color red600 = const Color(0xFFE53935);
  final Color red700 = const Color(0xFFD32F2F);
  final Color red800 = const Color(0xFFC62828);
  final Color red900 = const Color(0xFFB71C1C);
  final Color redA100 = const Color(0xFFFF8A80);
  final Color redA200 = const Color(0xFFFF5252);
  final Color redA400 = const Color(0xFFFF1744);
  final Color redA700 = const Color(0xFFD50000);

  // Pink
  final Color pink50 = const Color(0xFFFCE4EC);
  final Color pink100 = const Color(0xFFF8BBD0);
  final Color pink200 = const Color(0xFFF48FB1);
  final Color pink300 = const Color(0xFFF06292);
  final Color pink400 = const Color(0xFFEC407A);
  final Color pink500 = const Color(0xFFE91E63);
  final Color pink600 = const Color(0xFFD81B60);
  final Color pink700 = const Color(0xFFC2185B);
  final Color pink800 = const Color(0xFFAD1457);
  final Color pink900 = const Color(0xFF880E4F);
  final Color pinkA100 = const Color(0xFFFF80AB);
  final Color pinkA200 = const Color(0xFFFF4081);
  final Color pinkA400 = const Color(0xFFF50057);
  final Color pinkA700 = const Color(0xFFC51162);

  // Deep Purple
  final Color deepPurple50 = const Color(0xFFEDE7F6);
  final Color deepPurple100 = const Color(0xFFD1C4E9);
  final Color deepPurple200 = const Color(0xFFB39DDB);
  final Color deepPurple300 = const Color(0xFF9575CD);
  final Color deepPurple400 = const Color(0xFF7E57C2);
  final Color deepPurple500 = const Color(0xFF673AB7);
  final Color deepPurple600 = const Color(0xFF5E35B1);
  final Color deepPurple700 = const Color(0xFF512DA8);
  final Color deepPurple800 = const Color(0xFF4527A0);
  final Color deepPurple900 = const Color(0xFF311B92);
  final Color deepPurpleA100 = const Color(0xFFB388FF);
  final Color deepPurpleA200 = const Color(0xFF7C4DFF);
  final Color deepPurpleA400 = const Color(0xFF651FFF);
  final Color deepPurpleA700 = const Color(0xFF6200EA);

  // Indigo
  final Color indigo50 = const Color(0xFFE8EAF6);
  final Color indigo100 = const Color(0xFFC5CAE9);
  final Color indigo200 = const Color(0xFF9FA8DA);
  final Color indigo300 = const Color(0xFF7986CB);
  final Color indigo400 = const Color(0xFF5C6BC0);
  final Color indigo500 = const Color(0xFF3F51B5);
  final Color indigo600 = const Color(0xFF3949AB);
  final Color indigo700 = const Color(0xFF303F9F);
  final Color indigo800 = const Color(0xFF283593);
  final Color indigo900 = const Color(0xFF1A237E);
  final Color indigoA100 = const Color(0xFF8C9EFF);
  final Color indigoA200 = const Color(0xFF536DFE);
  final Color indigoA400 = const Color(0xFF3D5AFE);
  final Color indigoA700 = const Color(0xFF304FFE);

  // Blue
  final Color blue50 = const Color(0xFFE3F2FD);
  final Color blue100 = const Color(0xFFBBDEFB);
  final Color blue200 = const Color(0xFF90CAF9);
  final Color blue300 = const Color(0xFF64B5F6);
  final Color blue400 = const Color(0xFF42A5F5);
  final Color blue500 = const Color(0xFF2196F3);
  final Color blue600 = const Color(0xFF1E88E5);
  final Color blue700 = const Color(0xFF1976D2);
  final Color blue800 = const Color(0xFF1565C0);
  final Color blue900 = const Color(0xFF0D47A1);
  final Color blueA100 = const Color(0xFF82B1FF);
  final Color blueA200 = const Color(0xFF448AFF);
  final Color blueA400 = const Color(0xFF2979FF);
  final Color blueA700 = const Color(0xFF2962FF);

  // Light Blue
  final Color lightBlue50 = const Color(0xFFE1F5FE);
  final Color lightBlue100 = const Color(0xFFB3E5FC);
  final Color lightBlue200 = const Color(0xFF81D4FA);
  final Color lightBlue300 = const Color(0xFF4FC3F7);
  final Color lightBlue400 = const Color(0xFF29B6FC);
  final Color lightBlue500 = const Color(0xFF03A9F4);
  final Color lightBlue600 = const Color(0xFF039BE5);
  final Color lightBlue700 = const Color(0xFF0288D1);
  final Color lightBlue800 = const Color(0xFF0288D1);
  final Color lightBlue900 = const Color(0xFF01579B);
  final Color lightBlueA100 = const Color(0xFF80D8FF);
  final Color lightBlueA200 = const Color(0xFF40C4FF);
  final Color lightBlueA400 = const Color(0xFF00B0FF);
  final Color lightBlueA700 = const Color(0xFF0091EA);

  // Cyan
  final Color cyan50 = const Color(0xFFE0F7FA);
  final Color cyan100 = const Color(0xFFB2EBF2);
  final Color cyan200 = const Color(0xFF80DEEA);
  final Color cyan300 = const Color(0xFF4DD0E1);
  final Color cyan400 = const Color(0xFF26C6DA);
  final Color cyan500 = const Color(0xFF00BCD4);
  final Color cyan600 = const Color(0xFF00ACC1);
  final Color cyan700 = const Color(0xFF0097A7);
  final Color cyan800 = const Color(0xFF00838F);
  final Color cyan900 = const Color(0xFF006064);
  final Color cyanA100 = const Color(0xFF84FFFF);
  final Color cyanA200 = const Color(0xFF18FFFF);
  final Color cyanA400 = const Color(0xFF00E5FF);
  final Color cyanA700 = const Color(0xFF00B8D4);

  // Teal
  final Color teal50 = const Color(0xFFE0F2F1);
  final Color teal100 = const Color(0xFFB2DFDB);
  final Color teal200 = const Color(0xFF80CBC4);
  final Color teal300 = const Color(0xFF4DB6AC);
  final Color teal400 = const Color(0xFF26A69A);
  final Color teal500 = const Color(0xFF009688);
  final Color teal600 = const Color(0xFF00897B);
  final Color teal700 = const Color(0xFF00796B);
  final Color teal800 = const Color(0xFF00695C);
  final Color teal900 = const Color(0xFF004D40);
  final Color tealA100 = const Color(0xFFA7FFEB);
  final Color tealA200 = const Color(0xFF64FFDA);
  final Color tealA400 = const Color(0xFF1DE9B6);
  final Color tealA700 = const Color(0xFF00BFA5);

  // Green
  final Color green50 = const Color(0xFFE8F5E9);
  final Color green100 = const Color(0xFFC8E6C9);
  final Color green200 = const Color(0xFFA5D6A7);
  final Color green300 = const Color(0xFF81C784);
  final Color green400 = const Color(0xFF66BB6A);
  final Color green500 = const Color(0xFF4CAF50);
  final Color green600 = const Color(0xFF43A047);
  final Color green700 = const Color(0xFF388E3C);
  final Color green800 = const Color(0xFF2E7D32);
  final Color green900 = const Color(0xFF1B5E20);
  final Color greenA100 = const Color(0xFFB9F6CA);
  final Color greenA200 = const Color(0xFF69F0AE);
  final Color greenA400 = const Color(0xFF00E676);
  final Color greenA700 = const Color(0xFF00C853);

  // Light Green
  final Color lightGreen50 = const Color(0xFFF1F8E9);
  final Color lightGreen100 = const Color(0xFFDCEDC8);
  final Color lightGreen200 = const Color(0xFFC5E1A5);
  final Color lightGreen300 = const Color(0xFFAED581);
  final Color lightGreen400 = const Color(0xFF9CCC65);
  final Color lightGreen500 = const Color(0xFF8BC34A);
  final Color lightGreen600 = const Color(0xFF7CB342);
  final Color lightGreen700 = const Color(0xFF689F38);
  final Color lightGreen800 = const Color(0xFF558B2F);
  final Color lightGreen900 = const Color(0xFF33691E);
  final Color lightGreenA100 = const Color(0xFFCCFF90);
  final Color lightGreenA200 = const Color(0xFFB2FF59);
  final Color lightGreenA400 = const Color(0xFF76FF03);
  final Color lightGreenA700 = const Color(0xFF64DD17);

  // Lime
  final Color lime50 = const Color(0xFFF9FBE7);
  final Color lime100 = const Color(0xFFF0F4C3);
  final Color lime200 = const Color(0xFFE6EE9C);
  final Color lime300 = const Color(0xFFDCE775);
  final Color lime400 = const Color(0xFFD4E157);
  final Color lime500 = const Color(0xFFCDDC39);
  final Color lime600 = const Color(0xFFC0CA33);
  final Color lime700 = const Color(0xFFA4B42B);
  final Color lime800 = const Color(0xFF9E9D24);
  final Color lime900 = const Color(0xFF827717);
  final Color limeA100 = const Color(0xFFF4FF81);
  final Color limeA200 = const Color(0xFFEEFF41);
  final Color limeA400 = const Color(0xFFC6FF00);
  final Color limeA700 = const Color(0xFFAEEA00);

  // Yellow
  final Color yellow50 = const Color(0xFFFFFDE7);
  final Color yellow100 = const Color(0xFFFFF9C4);
  final Color yellow200 = const Color(0xFFFFF590);
  final Color yellow300 = const Color(0xFFFFF176);
  final Color yellow400 = const Color(0xFFFFEE58);
  final Color yellow500 = const Color(0xFFFFEB3B);
  final Color yellow600 = const Color(0xFFFDD835);
  final Color yellow700 = const Color(0xFFFBC02D);
  final Color yellow800 = const Color(0xFFF9A825);
  final Color yellow900 = const Color(0xFFF57F17);
  final Color yellowA100 = const Color(0xFFFFFF82);
  final Color yellowA200 = const Color(0xFFFFFF00);
  final Color yellowA400 = const Color(0xFFFFEA00);
  final Color yellowA700 = const Color(0xFFFFD600);

  // Amber
  final Color amber50 = const Color(0xFFFFF8E1);
  final Color amber100 = const Color(0xFFFFECB3);
  final Color amber200 = const Color(0xFFFFE082);
  final Color amber300 = const Color(0xFFFFD54F);
  final Color amber400 = const Color(0xFFFFCA28);
  final Color amber500 = const Color(0xFFFFC107);
  final Color amber600 = const Color(0xFFFFB300);
  final Color amber700 = const Color(0xFFFFA000);
  final Color amber800 = const Color(0xFFFF8F00);
  final Color amber900 = const Color(0xFFFF6F00);
  final Color amberA100 = const Color(0xFFFFE57F);
  final Color amberA200 = const Color(0xFFFFD740);
  final Color amberA400 = const Color(0xFFFFC400);
  final Color amberA700 = const Color(0xFFFFAB00);

  // Orange
  final Color orange50 = const Color(0xFFFFF3E0);
  final Color orange100 = const Color(0xFFFFE0B2);
  final Color orange200 = const Color(0xFFFFCC80);
  final Color orange300 = const Color(0xFFFFB74D);
  final Color orange400 = const Color(0xFFFFA726);
  final Color orange500 = const Color(0xFFFF9800);
  final Color orange600 = const Color(0xFFFB8C00);
  final Color orange700 = const Color(0xFFF57C00);
  final Color orange800 = const Color(0xFFEF6C00);
  final Color orange900 = const Color(0xFFE65100);
  final Color orangeA100 = const Color(0xFFFFD180);
  final Color orangeA200 = const Color(0xFFFFAB40);
  final Color orangeA400 = const Color(0xFFFF9100);
  final Color orangeA700 = const Color(0xFFFF6D00);

  // Deep Orange
  final Color deepOrange50 = const Color(0xFFFBE9A7);
  final Color deepOrange100 = const Color(0xFFFFCCBC);
  final Color deepOrange200 = const Color(0xFFFFAB91);
  final Color deepOrange300 = const Color(0xFFFF8A65);
  final Color deepOrange400 = const Color(0xFFFF7043);
  final Color deepOrange500 = const Color(0xFFFF5722);
  final Color deepOrange600 = const Color(0xFFF4511E);
  final Color deepOrange700 = const Color(0xFFE64A19);
  final Color deepOrange800 = const Color(0xFFD84315);
  final Color deepOrange900 = const Color(0xFFBF360C);
  final Color deepOrangeA100 = const Color(0xFFFF9E80);
  final Color deepOrangeA200 = const Color(0xFFFF6E40);
  final Color deepOrangeA400 = const Color(0xFFFF3D00);
  final Color deepOrangeA700 = const Color(0xFFDD2600);

  // Brown
  final Color brown50 = const Color(0xFFEFEBE9);
  final Color brown100 = const Color(0xFFD7CCC8);
  final Color brown200 = const Color(0xFFBCAAA4);
  final Color brown300 = const Color(0xFFA1887F);
  final Color brown400 = const Color(0xFF8D6E63);
  final Color brown500 = const Color(0xFF795548);
  final Color brown600 = const Color(0xFF6D4C41);
  final Color brown700 = const Color(0xFF5D4037);
  final Color brown800 = const Color(0xFF4E342E);
  final Color brown900 = const Color(0xFF3E2723);

  // Blue Grey
  final Color blueGrey50 = const Color(0xFFECEFF1);
  final Color blueGrey100 = const Color(0xFFCFD8DC);
  final Color blueGrey200 = const Color(0xFFB0BBC5);
  final Color blueGrey300 = const Color(0xFF90A4AE);
  final Color blueGrey400 = const Color(0xFF78909C);
  final Color blueGrey500 = const Color(0xFF607D8B);
  final Color blueGrey600 = const Color(0xFF546E7A);
  final Color blueGrey700 = const Color(0xFF455A64);
  final Color blueGrey800 = const Color(0xFF37474F);
  final Color blueGrey900 = const Color(0xFF263238);
}
