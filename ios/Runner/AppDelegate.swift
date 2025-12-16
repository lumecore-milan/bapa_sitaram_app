import Flutter
import UIKit
import Firebase


@main
@objc class AppDelegate: FlutterAppDelegate,FlutterImplicitEngineDelegate {
    
    
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {

      GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
      let channel = FlutterMethodChannel(
        name: "flutter.myapp.app/myChannel",
        binaryMessenger: engineBridge.applicationRegistrar.messenger()
      )
        
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                switch call.method {
                case "getAllUrl":
                    result(ios_getAllUrl())
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
      UNUserNotificationCenter.current().delegate = self
      UIApplication.shared.registerForRemoteNotifications()
 
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
