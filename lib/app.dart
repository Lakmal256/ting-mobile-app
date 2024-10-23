import 'package:app/cubits/cubits.dart';
import 'package:app/locator.dart';
import 'package:app/services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'blocs/blocs_exports.dart';
import 'package:provider/single_child_widget.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((event) {
      locate<PushNotificationController>().addItemFor(
        DismissiblePushNotification(
          content: event.notification?.body ?? "",
          color: Colors.white,
          onDismiss: (self) =>
              locate<PushNotificationController>().removeItem(self),
        ),
        const Duration(seconds: 5),
      );
    });
    super.initState();
  }

  List<Widget> getOverlayElements() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: listenable,
        builder: (context, snapshot) {
          return MultiBlocProvider(
            providers: _provideBlocs,
            child: MaterialApp.router(
                routerConfig: routerDelegate,
                builder: (context, child) {
                  child = EasyLoading.init()(
                      context, child); // initialize easy loading
                  child = Stack(fit: StackFit.passthrough, children: [
                    child,
                    ...getOverlayElements(),
                    Align(
                        alignment: Alignment.topLeft,
                        child: PushNotificationContainer(
                            children:
                                locate<PushNotificationController>().value))
                  ]);

                  return child;
                },
                theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.indigo.shade900),
                    useMaterial3: true),
                debugShowCheckedModeBanner: false),
          );
        });
  }

  final List<SingleChildWidget> _provideBlocs = [
    BlocProvider(create: (context) => LoginBloc()),
    BlocProvider(create: (context) => ToastBloc()),
    BlocProvider(create: (context) => SignupBloc()),
    BlocProvider(create: (context) => ProfileBloc()),
    BlocProvider(create: (context) => ForgetPassBloc()),
    BlocProvider(create: (context) => OtpBloc()),
    BlocProvider(create: (context) => TabViewCubit()),
    BlocProvider(create: (context) => CurrentLocationCubit()),
    BlocProvider(create: (context) => VendorsBloc()),
    BlocProvider(create: (context) => ProductsBloc()),
    BlocProvider(create: (context) => SearchBloc()),
    BlocProvider(create: (context) => HomeBloc()),
    BlocProvider(create: (context) => CartBloc()),
    BlocProvider(create: (context) => NotificationContentCubit()),
    BlocProvider(create: (context) => CheckoutBloc()),
    BlocProvider(create: (context) => SupportComplaintBloc()),
  ];

  Listenable get listenable =>
      Listenable.merge([locate<PushNotificationController>()]);
}
