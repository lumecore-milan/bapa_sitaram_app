import 'dart:core';

import 'package:bapa_sitaram/view/aarti.dart';
import 'package:bapa_sitaram/view/about.dart';
import 'package:bapa_sitaram/view/contact.dart';
import 'package:bapa_sitaram/view/detail_page.dart';
import 'package:bapa_sitaram/view/donation.dart';
import 'package:bapa_sitaram/view/my_donation.dart';
import 'package:bapa_sitaram/view/press_media.dart';
import 'package:bapa_sitaram/view/punam_list.dart';
import 'package:bapa_sitaram/view/settings.dart';
import 'package:bapa_sitaram/view/social_activity.dart';
import 'package:bapa_sitaram/view/user_registration.dart';
import 'package:bapa_sitaram/widget/custom_video_player.dart';
import 'package:bapa_sitaram/widget/custom_youtube_video_lpayer.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../models/app_loading.dart';
import '../models/home_detail.dart';
import '../services/loger_service.dart';
import '../view/download_posts.dart';
import '../view/events.dart';
import '../view/galary.dart';
import '../view/home.dart';
import '../view/image_view.dart';
import '../view/login.dart';
import '../view/menu_detail.dart';
import '../view/policy.dart';
import '../view/single_event_detail.dart';
import '../view/social_activity_detail.dart';
import '../view/splash.dart';
import '../view/virtual_darshan.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  try {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
        case myDonationRoute:
        return MaterialPageRoute(builder: (context) => MyDonationList());

      /*  case singleDetailRoute:
          String image='';
          String content='';
          String title='';
          if (settings.arguments != null) {
            final t = settings.arguments as Map<String,dynamic>;
            image=t['image']??'';
            content=t['content']??'';
            title=t['title']??'';
          }
        return MaterialPageRoute(builder: (context) => SingleDetailPage(imageUrl: image, content: content, title: title));*/
      case userRegistrationRoute:
        return MaterialPageRoute(
          builder: (context) => const UserRegistrationPage(),
        );
      case loginRoute:
        AppSettingModel detail = AppSettingModel();
        if (settings.arguments != null) {
          detail = settings.arguments as AppSettingModel;
        }

        return MaterialPageRoute(
          builder: (context) => LoginPage(detail: detail),
        );
      case homeRoute:
        AppSettingModel detail = AppSettingModel();
        if (settings.arguments != null) {
          detail = settings.arguments as AppSettingModel;
        }
        return MaterialPageRoute(
          builder: (context) => HomePage(detail: detail),
        );
      case punamListRoute:
        return MaterialPageRoute(builder: (context) => PunamListPage());
      case aartiRoute:
        Arti detail = Arti();
        if (settings.arguments != null) {
          detail = settings.arguments as Arti;
        }
        return MaterialPageRoute(
          builder: (context) => AartiPage(detail: detail),
        );
      case donationRoute:
        bool showAppBBar=false;
        if (settings.arguments != null) {
          showAppBBar = settings.arguments as bool;
        }
        return MaterialPageRoute(builder: (context) => DonationPage(showAppBar: showAppBBar));
      case pressRoute:
        return MaterialPageRoute(builder: (context) => const PressMedia());
      case socialActivityRoute:
        return MaterialPageRoute(
          builder: (context) => const SocialActivities(),
        );
      case contactRoute:
        return MaterialPageRoute(builder: (context) => ContactUs());
      case downloadPostRoute:
        return MaterialPageRoute(builder: (context) => const DownloadedPosts());
      case settingRoute:
        return MaterialPageRoute(builder: (context) => SettingPage());
      case galleryRoute:
        return MaterialPageRoute(builder: (context) => GalleryList());
      case aboutRoute:
        return MaterialPageRoute(builder: (context) => AboutUs());
      case eventsRoute:
        return MaterialPageRoute(builder: (context) => EventsPage());
      case virtualDarshanRoute:
        return MaterialPageRoute(builder: (context) => VirtualDarshan());

      case imageRoute:
        String url = '';
        if (settings.arguments != null) {
          url = settings.arguments as String;
        }
        return MaterialPageRoute(builder: (context) => ImageView(url: url));

      case menuDetailRoute:
        String title = '';
        dynamic d = [];
        if (settings.arguments != null) {
          final Map data = settings.arguments as Map<String, dynamic>;
          title = data['title'];
          d = data['data'] as List<dynamic>;
        }
        return MaterialPageRoute(
          builder: (context) => MenuDetailPage(title: title, detail: d),
        );
      case socialActivityDetailRoute:
        String title = '';
        dynamic d = [];
        if (settings.arguments != null) {
          final Map data = settings.arguments as Map<String, dynamic>;
          title = data['title'];
          d = data['data'] as Map<String, dynamic>;
        }
        return MaterialPageRoute(
          builder: (context) => SocialActivityDetail(title: title, detail: d),
        );
      case detailRoute:
        bool showAppbar = false;
        int index=-1;
        if (settings.arguments != null) {
          final Map<String,dynamic> temp= settings.arguments as Map<String,dynamic>;
          showAppbar=temp['showAppbar']??false;
          index=temp['index']??-1;
        }
        return MaterialPageRoute(
          builder: (context) => DetailPage(showAppbar: showAppbar, eventIndex: index),
        );
      case videoRoute:
        String path = '';
        if (settings.arguments != null) {
          path = (settings.arguments as String);
        }
        return MaterialPageRoute(
          builder: (context) => CustomVideoPlayer(path: path),
        );
      case youtubeVideoRoute:
        String detail = '';
        if (settings.arguments != null) {
          detail = settings.arguments as String;
        }
        return MaterialPageRoute(
          builder: (context) => CustomYoutubeVideoPlayer(url: detail),
        );
      case policyRoute:
        String title = '';
        String detail = '';
        if (settings.arguments != null) {
          final Map data = settings.arguments as Map<String, dynamic>;
          title = data['title'];
          detail = data['data'];
        }
        return MaterialPageRoute(
          builder: (context) => PolicyPage(detail: detail, title: title),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  } catch (e) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('No route defined for ${settings.name}')),
      ),
    );
  }
}

void navigate({
  required BuildContext context,
  required bool replace,
  required String path,
  bool removePreviousRoute = false,
  dynamic param,
}) {
  try {
    if (replace) {
      if (removePreviousRoute) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          path,
          arguments: param,
          (route) => false,
        );
      } else {
        Navigator.pushReplacementNamed(context, path, arguments: param);
      }
    } else {
      Navigator.pushNamed(context, path, arguments: param);
    }
  } catch (e) {
    LoggerService().log(message: e.toString());
  }
}
