import 'dart:async';

import 'package:bapa_sitaram/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show AppLifecycleListener, WidgetsBinding;

import '../services/firebase_service.dart';
import 'connectivity_service.dart';
import 'enums.dart';


class AppEvent {
  AppEvent({required this.type, this.data});
  final AppEventType type;
  final dynamic data;
}



class AppEventsStream {

  factory AppEventsStream() => _instance;
  AppEventsStream._internal();
  static final AppEventsStream _instance = AppEventsStream._internal();
  final StreamController<AppEvent> _controller =StreamController<AppEvent>.broadcast();
  Stream<AppEvent> get stream => _controller.stream;
  late AppLifecycleListener _lifecycleListener;
  void addEvent(AppEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }
  void initialize(){
    _lifecycleListener = AppLifecycleListener(
      onPause: () {
        AppEventsStream().addEvent(
          AppEvent(type: AppEventType.appPaused),
        );
      },
      onResume: () {
        AppEventsStream().addEvent(
          AppEvent(type: AppEventType.appResumed),
        );
      },
      onInactive: () {
        AppEventsStream().addEvent(
          AppEvent(type: AppEventType.appInActive),
        );
      },
      onDetach: () {
        AppEventsStream().addEvent(
          AppEvent(type: AppEventType.appDetached),
        );
      },
    );
    ConnectivityService().startListening();
    if(!kIsWeb) {

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await NotificationServiceMobile().getLaunchDetails();
        await FirebaseService().getInitialMessage();
      });
    }
  }
  void dispose(){
    _controller.close();
    _lifecycleListener.dispose();
    if(!kIsWeb) {
      ConnectivityService().dispose();
    }
  }
}
