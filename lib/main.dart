import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/services/connectivity_service.dart';
import 'package:bapa_sitaram/services/device_info_service.dart';
import 'package:bapa_sitaram/services/firebase_service.dart';
import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:bapa_sitaram/services/notification_service.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService().initPreference();

  runApp(const MyApp());
  Future.microtask(runMicrotask);
}

Future<void> runMicrotask() async {
  try {
    //OneSignal.initialize("YOUR_APP_ID");

    ConnectivityService().setPingUrl(pingUrl: APIConstant().apiMainMenu);
    await Future.wait([
      FirebaseService().initialize(
        options: const {
          'apiKey': 'AIzaSyCpwuGMmEgNaJ3v0zvwMEL1z02EnEZmEUs',
          'appId': '1:37795912856:android:3ef0533bd290649696c4ed',
          'messagingSenderId': '',
          'projectId': 'bapa-sitaram-7a3b2',
        },
      ),
      NotificationServiceMobile().initialize(),
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
