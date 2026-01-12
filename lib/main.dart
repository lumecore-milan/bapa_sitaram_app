import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/services/device_info_service.dart';
import 'package:bapa_sitaram/services/firebase_service.dart';
import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:bapa_sitaram/utils/events.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService().initPreference();
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'prod');
  await APIConstant().setUrl(isDev: flavor == 'dev');

  runApp(const MyApp());
  Future.microtask(runMicrotask);
}

Future<void> runMicrotask() async {
  try {
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(false);
    OneSignal.initialize('302d18f7-d9fa-45e3-989f-0c7221f32a20');
    await OneSignal.Notifications.requestPermission(true);
    OneSignal.LiveActivities.setupDefault();
    OneSignal.Notifications.addClickListener((event) {
      final Map<String, dynamic> data = event.notification.additionalData ?? {};

      if (data.isNotEmpty) {
        pendingDetail = NotificationCLickDetail(id: '${data['value'] ?? ''}', type: '${data['type'] ?? ''}');
       Future.delayed(const Duration(milliseconds: 700)).then((time) {
          notificationClicked.sink.add(pendingDetail);
        });
      }
    });
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      if (PreferenceService().getString(key: AppConstants().prefKeyNotificationEnabled) != 'false') {
        event.notification.display();
      }
    });
    await Future.wait([
      FirebaseService().initialize(options: const {'apiKey': 'AIzaSyCpwuGMmEgNaJ3v0zvwMEL1z02EnEZmEUs', 'appId': '1:37795912856:android:3ef0533bd290649696c4ed', 'messagingSenderId': '', 'projectId': 'bapa-sitaram-7a3b2'}),
      //NotificationServiceMobile().initialize(),
    ]);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await Future.wait([DeviceInfoService().load()]);
  } catch (e) {
    LoggerService().log(message: 'error in app initialization $e');
  }
}
