import Flutter
import UIKit
import Firebase
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate,FlutterImplicitEngineDelegate {
    
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {

      GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

//      let batteryChannel = FlutterMethodChannel(
//        name: "samples.flutter.dev/battery",
//        binaryMessenger: engineBridge.applicationRegistrar.messenger()
//      )
//      let factory = FLNativeViewFactory(messenger: engineBridge.applicationRegistrar.messenger())
    }

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      UNUserNotificationCenter.current().delegate = self
      UIApplication.shared.registerForRemoteNotifications()
 
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
