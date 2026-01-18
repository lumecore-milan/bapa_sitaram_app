import 'dart:io';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/services/app_events.dart';
import 'package:bapa_sitaram/services/connectivity_service.dart';
import 'package:bapa_sitaram/services/enums.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:bapa_sitaram/utils/custom_dialogs.dart';
import 'package:bapa_sitaram/utils/helper.dart';
//import 'package:bapa_sitaram/utils/events.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/constants/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    LoggerService().showLogInReleaseMode = true;

    super.initState();
    HelperService().initSoundSources(
      soundFiles: ['assets/sound/shankh_audio.mp3', 'assets/sound/bell_audio.mp3', 'assets/sound/bapa_sitaram.mp3', 'assets/sound/aarti_sound_final.mp3', 'assets/sound/bg_devotional.mp3', 'assets/sound/bg_devotional_1.mp3'],
    );
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    if (Platform.isIOS) {
      ConnectivityService().startListening();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppEventsStream().stream.listen((event) async {
          if (event.type == AppEventType.internetDisConnected) {
            if (AppConstants().isDialogOpen == false) {
              AppConstants().isDialogOpen = true;
              noInternetDialog();
            }
          } else if (event.type == AppEventType.internetConnected) {
            if (AppConstants().isDialogOpen == true) {
              AppConstants().isDialogOpen = false;
              Helper.closeLoader();
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    return MaterialApp(
      supportedLocales: const <Locale>[Locale('en'), Locale('de')],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: CustomColors().layoutPrimaryBackground),
      scaffoldMessengerKey: AppConstants().scaffoldMessengerKey,
      navigatorKey: AppConstants().navigatorKey,
      title: 'Flutter Demo',
      initialRoute: splashRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
