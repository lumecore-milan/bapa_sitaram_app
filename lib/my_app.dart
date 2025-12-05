import 'package:bapa_sitaram/constants/app_colors.dart';
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
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
