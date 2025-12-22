import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({super.key});

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  late Widget indicator;
  @override
  void initState() {
    if (kIsWeb) {
      indicator = const CircularProgressIndicator();
    } else if (Platform.isIOS) {
      indicator = const CupertinoActivityIndicator(animating: true, radius: 30);
    } else {
      indicator = const CircularProgressIndicator();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        height: SizeConfig().height,
        width: SizeConfig().width,
        child: Center(child: indicator),
      ),
    );
  }
}
