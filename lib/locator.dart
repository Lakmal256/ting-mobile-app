import 'package:get_it/get_it.dart';
import 'package:app/services/services.dart';

GetIt getIt = GetIt.instance;

class LocatorConfig {
  LocatorConfig({
    required this.appName,
    required this.flavor,
    required this.baseUrl,
    required this.baseUrlMarketplace,
  });

  final String appName;
  final String flavor;
  final String baseUrl;
  final String baseUrlMarketplace;
}

setupServiceLocator(LocatorConfig config) async {
  getIt.registerSingleton(config);
  getIt.registerSingleton(CloudMessagingHelperService());
  getIt.registerSingleton(PushNotificationController());
}

T locate<T extends Object>() => GetIt.instance<T>();
