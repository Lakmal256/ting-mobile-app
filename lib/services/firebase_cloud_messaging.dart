import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessagingHelperService {
  CloudMessagingHelperService();

  NotificationSettings? notificationSettings;

  String? deviceToken;

  Object? error;

  Future<CloudMessagingHelperService> requestPermission() async {
    notificationSettings = await FirebaseMessaging.instance.requestPermission(
      provisional: true,
      alert: true,
      sound: true,
      badge: true,
    );
    return this;
  }

  _setDeviceToken() async {
    final deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken == null) throw Exception();

    this.deviceToken = deviceToken;
    return this;
  }

  Future<CloudMessagingHelperService> registerDeviceToken() async {
    try {
      await _setDeviceToken();
      // TODO
      // call the deviceToken update api
    } catch (error) {
      this.error = error;
    }
    return this;
  }

  bool get hasError => error != null;
}
