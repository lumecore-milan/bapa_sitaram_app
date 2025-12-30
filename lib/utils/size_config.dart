import 'package:flutter/material.dart';

import 'package:bapa_sitaram/services/enums.dart';

class SizeConfig {
  factory SizeConfig() => _instance;
  SizeConfig._internal();
  static final SizeConfig _instance = SizeConfig._internal();

  double width = 0;
  double height = 0;
  late double blockSizeHorizontal;
  late double blockSizeVertical;

  late DeviceType deviceType;
  late double textScaleFactor;

  void init({required BuildContext context}) {
    final mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;

    if (width < 600) {
      deviceType = DeviceType.mobile;
    } else if (width < 1200) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.desktop;
    }

    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;
    textScaleFactor = mediaQuery.textScaler.scale(1.0);
  }
}

extension SizeExtension on num {
  double get sw => this * SizeConfig().blockSizeHorizontal;
  double get sh => this * SizeConfig().blockSizeVertical;
  /* double get sp =>
      (this * SizeConfig().blockSizeHorizontal) / SizeConfig().textScaleFactor;*/
  double get sp {
    final scale = SizeConfig().textScaleFactor;
    final shortestSide = SizeConfig().width < SizeConfig().height ? SizeConfig().width : SizeConfig().height;

    return (this * (shortestSide / 100)) / scale;
  }
}
