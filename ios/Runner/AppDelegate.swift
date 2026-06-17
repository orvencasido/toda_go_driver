import Flutter
import UIKit
<<<<<<< HEAD
=======
import GoogleMaps
>>>>>>> 9d63913 (Initial commit from Antigravity project)

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
<<<<<<< HEAD
=======
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
>>>>>>> 9d63913 (Initial commit from Antigravity project)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
