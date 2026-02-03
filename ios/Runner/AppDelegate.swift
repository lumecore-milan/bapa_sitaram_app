import Flutter
import UIKit
import Firebase
import FirebaseAuth
import FirebaseAppCheck

@main
@objc class AppDelegate: FlutterAppDelegate,FlutterImplicitEngineDelegate {
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {

      GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
      let channel = FlutterMethodChannel(
        name: "flutter.myapp.app/myChannel",
        binaryMessenger: engineBridge.applicationRegistrar.messenger()
      )
      print("[AppDelegate] Initialized FlutterMethodChannel: flutter.myapp.app/myChannel")
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                switch call.method {
                case "getAllUrl":
                    print("[AppDelegate] Handling method 'getAllUrl'")
                    let dd=ios_getAllUrl();
                    result(dd)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        
        
      //let factory = FLNativeViewFactory(messenger: engineBridge.applicationRegistrar.messenger())
    }

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      FirebaseApp.configure();
    
#if DEBUG
  AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
#else
  AppCheck.setAppCheckProviderFactory(DeviceCheckProviderFactory())
#endif
        
      UNUserNotificationCenter.current().delegate = self
      UIApplication.shared.registerForRemoteNotifications()
 
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Auth.auth().setAPNSToken(deviceToken, type: .prod)

      print("✅ APNs token received")
    }
    override func application(
      _ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable : Any],
      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print("📩 Silent push received:", userInfo)
       
          if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
          }
        completionHandler(.newData)
    }

}

