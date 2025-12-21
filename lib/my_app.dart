import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/services/app_events.dart';
import 'package:bapa_sitaram/services/enums.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/utils/size_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/app_constant.dart';
import 'constants/routes.dart';

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
      soundFiles: [
        'assets/sound/shankh_audio.mp3',
        'assets/sound/bell_audio.mp3',
        'assets/sound/bapa_sitaram.mp3',
      ],
    );
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //  ConnectivityService().startListening();

    AppEventsStream().stream.listen((event) async {
      if (event.type == AppEventType.internetDisConnected) {
        AppConstants().isDialogOpen = true;
        //  noInternetDialog();
      } else if (event.type == AppEventType.internetConnected) {
        AppConstants().isDialogOpen = false;
        //  Helper.closeLoader();
      }
    });

    /*Future.delayed(Duration(seconds: 10)).then((t) {
      notificationClicked.sink.add(
        NotificationCLickDetail(
          id: 'https://vimeo.com/347119375?fl=pl&fe=cm',
          type: 'liveArti',
        ),
      );
    });*/
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
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors().layoutPrimaryBackground,
      ),
      scaffoldMessengerKey: AppConstants().scaffoldMessengerKey,
      navigatorKey: AppConstants().navigatorKey,
      title: 'Flutter Demo',
      initialRoute: splashRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
