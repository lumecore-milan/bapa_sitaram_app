
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';



//import 'package:flutter_local_notifications/flutter_local_notifications.dart';


/*
@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();

  final port = IsolateNameServer.lookupPortByName('callback_port');
  port?.send(message.data);
}*/

class FirebaseService {
  factory FirebaseService() => _instance;
  FirebaseService._internal();
  static final FirebaseService _instance = FirebaseService._internal();

  Future<void> initialize({required Map<String, dynamic> options}) async {
    await Firebase.initializeApp();
  }

  Future<void> getInitialMessage() async {
   /* try {
      RemoteMessage? msg = await FirebaseMessaging.instance.getInitialMessage();
      if (msg != null) {
        AppEventsStream().addEvent(
          AppEvent(type: AppEventType.notificationClick, data: msg),
        );
      }
    } catch (e) {
      //
    }*/
  }

  Future<String> getFcmToken() async {
    String token = '';
   /* try {
      token = PreferenceService().getString(key: 'fcmToken');
      if (token.isEmpty) {
        token = await FirebaseMessaging.instance.getToken() ?? '';
        PreferenceService().setString(key: 'fcmToken', value: token);
      }
    } catch (e) {
      LoggerService().log(
        message: 'error occurred while getting fcm token===>${e.toString()}',
      );
    }*/
    return token;
  }
}
