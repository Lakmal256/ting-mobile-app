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
      apiKey: "AIzaSyB8BRgUXl2Wcp5wPDA1GFBXg842hMEcDws",
      appId: "1:1040637403617:android:67a016be5b5cd489d032a0",
      messagingSenderId: "1040637403617",
      projectId: "dev-ting",
      storageBucket: "dev-ting.appspot.com",
    ),
    (TargetPlatform.iOS) => const FirebaseOptions(
      apiKey: "AIzaSyCsaiAO2YtfgMSqtiYApZGjc6b4SG24GNM",
      appId: "1:1040637403617:ios:945152fd44fa6b17d032a0",
      messagingSenderId: "1040637403617",
      projectId: "dev-ting",
      storageBucket: "dev-ting.appspot.com",
      androidClientId: "1040637403617-moa0or3uum83rlre525uv51055f50avi.apps.googleusercontent.com",
      iosClientId: "1040637403617-6h5p9a68crp8cp777dp634ivitmkb29h.apps.googleusercontent.com",
      iosBundleId: "com.ting.market",
    ),
    _ => throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    ),
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator(LocatorConfig(
      appName: "Ting-dev",
      flavor: "development",
      baseUrl: "https://um.dev.edine.lk",
      baseUrlMarketplace: "https://marketplace.api.dev.edine.lk"));

  AuthHandler();
  await Firebase.initializeApp(options: PlatformFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const App());
}
