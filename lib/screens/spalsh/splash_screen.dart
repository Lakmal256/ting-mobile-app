import 'package:app/services/app_routers.dart';
import 'package:app/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/blocs_exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);

  @override
  void initState() {
    final loginBloc = context.read<LoginBloc>();
    loginBloc.add(CheckLoggedInEvent());

    loginBloc.stream.listen((state) {
      if (state.status == LoginStatus.success) {
        context.read<ProfileBloc>().add(const FetchProfileDataEvent());
        Future.delayed(5.seconds)
            .whenComplete(() => context.go(AppRoutes.authorized));
      } else if (state.status == LoginStatus.notLoggedIn) {
        Future.delayed(5.seconds)
            .whenComplete(() => context.go(AppRoutes.unauthorized));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssestPath.assestBackgroundPath),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                  top: size.width / 2 - 10, // Top edge of the Stack
                  // left: 0, // Left edge of the Stack
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/app_icon.png"),
                      ),
                    ),
                  )
                      .animate(controller: _controller)
                      .fade(duration: 1500.ms)
                      .then(delay: 200.ms)
                      .moveY(
                          delay: 400.ms,
                          begin: 0,
                          end: size.width / 2 - 120,
                          duration: 300.ms)
                      .scale(
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(0.8, 0.8),
                        curve: Curves.easeIn,
                      )
                      .moveY(
                        begin: 0,
                        end: size.width / 2 - 90,
                      )
                      .then()
                      .scale(
                        begin: const Offset(.8, 0.8),
                        end: const Offset(0.9, 0.9),
                        curve: Curves.ease,
                      )
                      .moveY(
                        begin: 0,
                        end: -50,
                        duration: 400.ms,
                        curve: Curves.easeInOut, // drop down animation finish
                      )
                      .then(delay: 400.ms)
                      .moveX(
                          begin: 0,
                          end: -100,
                          curve: Curves.ease,
                          duration: 300.ms)), // move icon to left
            ],
          ),
        ),
      ),
    );
  }
}
