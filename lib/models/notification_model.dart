import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors;

class MyNotificationModel {
  MyNotificationModel({
    required this.title,
    required this.action,
    required this.channelKey,
    required this.message,
    required this.notificationId,
    this.imageURL = '',
    this.largeIcon = '',
    this.locked = false,
    this.criticalAlert = true,
    this.wakeUpScreen = true,
    this.autoDismissible = true,
    this.backgroundColor = Colors.white,
    this.fontColor = Colors.black,
    this.notificationTapData = const {},
    this.notificationSound = '',
  });

  String title;
  String message;
  final String notificationId;
  final String action, channelKey;
  final Color backgroundColor, fontColor;

  Map<String, String> notificationTapData = {};

  String imageURL, largeIcon;
  String notificationSound;
  List<MyNotificationButtons> buttons = List.empty(growable: true);

  bool autoDismissible, criticalAlert, wakeUpScreen, locked, isTimerNotification = false;

  /// 📌 JSON for logging
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "message": message,
      "notificationId": notificationId,
      "action": action,
      "channelKey": channelKey,
      "imageURL": imageURL,
      "largeIcon": largeIcon,
      "locked": locked,
      "criticalAlert": criticalAlert,
      "wakeUpScreen": wakeUpScreen,
      "autoDismissible": autoDismissible,
      "backgroundColor": backgroundColor.value,
      "fontColor": fontColor.value,
      "notificationTapData": notificationTapData,
      "notificationSound": notificationSound,
      "buttons": buttons.map((e) => e.toJson()).toList(),
    };
  }
}

class MyNotificationButtons {
  MyNotificationButtons({required this.key, required this.title, required this.color});

  final String title, key;
  final Color color;

  Map<String, dynamic> toJson() {
    return {"key": key, "title": title, "color": color.value};
  }
}
