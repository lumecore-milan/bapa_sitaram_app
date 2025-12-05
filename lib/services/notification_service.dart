import 'dart:convert';
import 'package:bapa_sitaram/services/download/download_helper_mobile.dart';
import 'package:bapa_sitaram/services/permission_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification_model.dart';
import 'app_events.dart';
import 'enums.dart';
import 'loger_service.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

class NotificationServiceMobile {
  factory NotificationServiceMobile() => _instance;
  NotificationServiceMobile._internal();
  static final NotificationServiceMobile _instance =
  NotificationServiceMobile._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final  AndroidInitializationSettings _androidInit =
  AndroidInitializationSettings('@drawable/notification_icon');
  final DarwinInitializationSettings _iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,

  );


  Future<void> getLaunchDetails() async {
    try {

      final NotificationAppLaunchDetails? receivedAction =
      await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
      final bool launchedFromNotification =
          receivedAction?.didNotificationLaunchApp ?? false;
      final String? payload = launchedFromNotification
          ? receivedAction!.notificationResponse?.payload
          : null;
      if (receivedAction != null) {
        AppEventsStream().addEvent(
          AppEvent(
            type: AppEventType.initialNotificationReceived,
            data: receivedAction,
          ),
        );
      } else {
        print('App was not launched by a notification');
      }
    } catch (e) {
      //
    }
  }

  Future<void> initialize() async {
    try {

      final InitializationSettings initSettings = InitializationSettings(
        android: _androidInit,
        iOS: _iosInit,
      );
      await _flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'high_importance_channel', // name
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('slow_spring_board')
      );
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      LoggerService().log(
        message: 'Error while creating notification channel ${e.toString()}',
      );
    }
  }

  Future<void> showNotification({required MyNotificationModel payload}) async {
    String imagePath='';
    try {
      final bool permission=await PermissionService().requestNotificationPermission();
      if(permission==false){
        return;
      }
      if (payload.channelKey.isNotEmpty) {

        StyleInformation style=DefaultStyleInformation(false,false);
        if(payload.imageURL.isNotEmpty){
          LoggerService().log(message: 'image file provided');
          imagePath=await  DownloadServiceMobile().download(url: payload.imageURL)??'';
         if(imagePath.isNotEmpty) {
           LoggerService().log(message: 'image notification downloaded');
           style = BigPictureStyleInformation(
             FilePathAndroidBitmap(imagePath),
             contentTitle: payload.title,
             summaryText: payload.message);
         }else{
           LoggerService().log(message: 'image file could not be download');
         }
        }
        AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'high_importance_channel',
          icon: '@mipmap/ic_launcher',
    //      largeIcon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation:style,
          playSound: payload.notificationSound.isNotEmpty,
          sound: RawResourceAndroidNotificationSound(payload.notificationSound)
        );

        NotificationDetails details = NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(

            attachments:imagePath.isNotEmpty ? [DarwinNotificationAttachment(imagePath,hideThumbnail: false)]:null,
            presentSound: payload.notificationSound.isNotEmpty,
            sound: payload.notificationSound,
            interruptionLevel: InterruptionLevel.critical,
          ),
        );

        await _flutterLocalNotificationsPlugin.show(
          int.parse(payload.notificationId),
          payload.title,
          payload.message,
          details,
          payload: json.encode({
            'id':payload.notificationId,
          }),
        );
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }
}
