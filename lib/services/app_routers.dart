import 'package:app/data/data.dart';
import 'package:app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const authorized = '/authorized';
  static const unauthorized = '/unauthorized';
  static const notFoundHome = '/';

  static const signin = '/unauthorized/signin';
  static const signup = '/unauthorized/signup';
  static const forgot = '/unauthorized/forgot';
  static const otp = '/unauthorized/otp/:number/:isForget';
  static const updatePassword = '/unauthorized/update_password/:code';

  static const home = '/authorized/home';
  static const liquor = '/authorized/liqour';
  static const search = '/authorized/search';
  static const cart = '/authorized/cart';
  static const profile = '/authorized/profile';
  static const department = "/department";
  static const settings = '/settings';
  static const address = '/address';
  static const vendor = '/vendor';
  static const vendorInfo = '/vendor/info';
  static const product = '/product';

  static const checkout = '/checkout';
  static const selectPayment = '/select_payment';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

GoRouter routerDelegate = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash, // Set splash screen as initial location
    routes: [
      GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen()),
      GoRoute(
          path: AppRoutes.unauthorized,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const SignUpScreen()),
      GoRoute(
          path: AppRoutes.forgot,
          builder: (context, state) => ForgetPasswordScreen()),
      GoRoute(
          name: AppRoutes.otp,
          path: AppRoutes.otp,
          builder: (context, state) => VerifyOtpScreen(
              isForget: bool.tryParse(state.pathParameters['isForget']!)!,
              mobNumber: state.pathParameters['number']!)),
      GoRoute(
        path: AppRoutes.updatePassword,
        name: AppRoutes.updatePassword,
        builder: (context, state) =>
            UpdatePassScreen(authCode: state.pathParameters['code']!),
      ),
      GoRoute(
          path: AppRoutes.authorized,
          redirect: (context, state) => AppRoutes.home),
      GoRoute(
          path: AppRoutes.notFoundHome,
          redirect: (context, state) => AppRoutes.home),

      GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const ProfileSettingsScreen()),
      GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const ProfileSettingsScreen()),

      // GoRoute(
      //     path: AppRoutes.department,
      //     builder: (context, state) => const DepartmentScreen()),
      GoRoute(
          path: AppRoutes.vendor,
          builder: (context, state) => const VendorViewScreen()),
      GoRoute(
          path: AppRoutes.vendorInfo,
          builder: (context, state) => VendorProfileInfoScreen(
              profileModel: state.extra! as VendorProfileModel)),
      GoRoute(
          path: AppRoutes.product,
          builder: (context, state) => ProductViewScreen(
              prodcutInfoModel: state.extra! as ProductInfoModel)),
      GoRoute(
          path: AppRoutes.checkout,
          builder: (context, state) => const CheckoutScreen()),
      GoRoute(
          path: AppRoutes.selectPayment,
          builder: (context, state) => const SelectPaymentScreen()),

      // shell
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        navigatorKey: _shellNavigatorKey,
        routes: [
          GoRoute(
            path: AppRoutes.home,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.liquor,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const LiquorScreen(),
          ),
          GoRoute(
            path: AppRoutes.search,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const SearchScreenView(),
          ),
          GoRoute(
            path: AppRoutes.address,
            builder: (context, state) => const AddressScreen(),
          ),
          GoRoute(
            path: AppRoutes.cart,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ]);
