import 'dart:async';
import 'dart:developer';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:app/locator.dart';
import 'package:app/services/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late String email;

  LoginBloc() : super(const LoginState()) {
    on<LoginButtonPressedEvent>(loginButtonPressedEvent);
    on<GoogleSigninButtonPressEvent>(googleSigninButtonPressEvent);
    on<CheckLoggedInEvent>(checkLoggedInEvent);
  }

  Future<void> loginButtonPressedEvent(
      LoginButtonPressedEvent event, Emitter<LoginState> emit) async {
    emit(const LoginState(status: LoginStatus.loading));

    final usernameValid = ValidationService.isValidEmail(event.email);
    final passwordValid = ValidationService.isValidPassword(event.password);

    // validate text inputs
    if (usernameValid != 'valid') {
      emit(LoginState(status: LoginStatus.failure, message: usernameValid));
    } else if (passwordValid != 'valid') {
      emit(LoginState(status: LoginStatus.failure, message: passwordValid));
    } else {
      try {
        UserLoginModel model = await AuthHandler()
            .userSignIn(email: event.email, pass: event.password);

        final userPreferences =
            UserPreferencesRepository(await SharedPreferences.getInstance());

        userPreferences.saveUser(model);

        email = event.email;

        await locate<CloudMessagingHelperService>().requestPermission();
        await locate<CloudMessagingHelperService>().registerDeviceToken();

        log("Sucess");

        emit(LoginState(
            message: model.loggedUser.identityId, status: LoginStatus.success));
      } on AuthException catch (e) {
        emit(LoginState(message: e.message, status: LoginStatus.failure));
      } catch (e) {
        emit(const LoginState(
            message: "Something went wrong!", status: LoginStatus.failure));
      }
    }
  }

  FutureOr<void> googleSigninButtonPressEvent(
      GoogleSigninButtonPressEvent event, Emitter<LoginState> emit) async {
    emit(const LoginState(status: LoginStatus.loading));
    UserDataModel? model =
        await GoogleSigninSevrice().googleGetUserData(isLogin: true);
    if (model!.email.isEmpty) {
      emit(const LoginState(
          status: LoginStatus.failure, message: 'Google sign-in\nfailed'));
    } else {
      try {
        var response = await AuthRepositories().userSocialLogin(
            email: model.email,
            socialType: 'google',
            accessToken: model.credentials.accessToken!);

        final userPreferences =
            UserPreferencesRepository(await SharedPreferences.getInstance());
        userPreferences.saveUser(response);

        await locate<CloudMessagingHelperService>().requestPermission();
        await locate<CloudMessagingHelperService>().registerDeviceToken();

        emit(const LoginState(status: LoginStatus.success));
      } on AuthException catch (e) {
        emit(LoginState(message: e.message, status: LoginStatus.failure));
      } catch (e) {
        emit(const LoginState(
            message: "Something went wrong!", status: LoginStatus.failure));
      }
    }
  }

  Future<void> checkLoggedInEvent(
      CheckLoggedInEvent event, Emitter<LoginState> emit) async {
    // Perform the check if user is already logged in
    final loggedInUser = await AuthRepositories().isSignedIn();

    if (loggedInUser) {
      emit(const LoginState(status: LoginStatus.success));
    } else {
      emit(const LoginState(
          status: LoginStatus.notLoggedIn)); // Emit with status as null
    }
  }
}
