import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    registerForNotification()
    GMSServices.provideAPIKey("AIzaSyCsaiAO2YtfgMSqtiYApZGjc6b4SG24GNM")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func registerForNotification(){
    UNUserNotificationCenter.current()
        .requestAuthorization(options : [.alert, .sound, .badge]){ granted, error in
        print("Permission granted : \(granted)")
    }
  }
}
