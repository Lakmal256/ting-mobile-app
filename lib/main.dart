import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/app.dart';
import 'package:app/data/data.dart';
import 'package:app/locator.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PlatformFirebaseOptions {
  static FirebaseOptions get currentPlatform => switch (defaultTargetPlatform) {
        (TargetPlatform.android) => const FirebaseOptions(
            apiKey: String.fromEnvironment("FIREBASE_OPTIONS_ANDROID_APIKEY"),
            appId: String.fromEnvironment("FIREBASE_OPTIONS_ANDROID_APP_ID"),
            messagingSenderId: String.fromEnvironment("FIREBASE_OPTIONS_ANDROID_MESSAGING_SENDER_ID"),
            projectId: String.fromEnvironment("FIREBASE_OPTIONS_ANDROID_PROJECT_ID"),
            storageBucket: String.fromEnvironment("FIREBASE_OPTIONS_ANDROID_STORAGE_BUCKET"),
          ),
        (TargetPlatform.iOS) => const FirebaseOptions(
            apiKey: String.fromEnvironment("FIREBASE_OPTIONS_IOS_APIKEY"),
            appId: String.fromEnvironment("FIREBASE_OPTIONS_IOS_APP_ID"),
            messagingSenderId: String.fromEnvironment("FIREBASE_OPTIONS_IOS_MESSAGING_SENDER_ID"),
            projectId: String.fromEnvironment("FIREBASE_OPTIONS_IOS_PROJECT_ID"),
            storageBucket: String.fromEnvironment("FIREBASE_OPTIONS_IOS_STORAGE_BUCKET"),
            androidClientId: String.fromEnvironment("FIREBASE_OPTIONS_ANDROID_CLIENT_ID"),
            iosClientId: String.fromEnvironment("FIREBASE_OPTIONS_IOS_CLIENT_ID"),
            iosBundleId: String.fromEnvironment("FIREBASE_OPTIONS_IOS_BUNDLE_ID"),
          ),
        _ => throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.',
          ),
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator(LocatorConfig(
      appName: const String.fromEnvironment("APP_NAME"),
      flavor: const String.fromEnvironment("FLAVOR"),
      baseUrl: const String.fromEnvironment("BASE_URL"),
      baseUrlMarketplace: const String.fromEnvironment("BASE_URL_MARKETPLACE")));

  AuthHandler();
  await Firebase.initializeApp(options: PlatformFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const App());
}
