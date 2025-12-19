import 'package:flutter/material.dart';

class AppConstants {

  final String androidAppVersion="9";
  final String iOSAppVersion="1";

  factory AppConstants() => _instance;
  AppConstants._internal();
  static final AppConstants _instance = AppConstants._internal();
  bool get isEncryptionEnabled => false;
  bool isDialogOpen = false;
  final String authToken = 'authorization';
  final String themeData = 'themeData';
  final String methodChannel = 'flutter.myapp.app/myChannel';
  final String prefKeyFcmToken = 'fcmToken';
  final String prefKeyDeviceInfo = 'deviceInfo';
  final String prefKeyIsLoggedIn = 'isLoggedIn';
  final String prefKeyIsRegistered = 'isRegistered';
  final String prefKeyMobile = 'mobileNumber';
  final String prefKeyUserDetail = 'userDetail';
  final String prefKeyUserId = 'userId';
  final String prefKeyEncKey = 'encKey';
  final String prefKeyIV = 'encIV';
  final String prefKeyNotificationEnabled= 'notificationEnabled';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

}
