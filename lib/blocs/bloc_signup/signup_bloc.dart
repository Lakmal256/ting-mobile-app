// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:app/data/data.dart';
import 'package:app/services/google_sign_in_service.dart';
import 'package:app/services/validation_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  late String email;
  late String password;
  //below two data's need to resned otp func
  late ApplyResponseModel model;
  late SignupButtonPressEvent signupButtonEvent;

  SignupBloc() : super(const SignupState()) {
    on<SignupButtonPressEvent>(signupButtonPressEvent);
    on<SignUpGoogleActionButtonEvent>(signUpGoogleActionButtonEvent);
  }

  FutureOr<void> signupButtonPressEvent(
      SignupButtonPressEvent event, Emitter<SignupState> emit) async {
    emit(const SignupState(status: SignUpStatus.loading));

    // Validate password
    var passwordValid = ValidationService.isValidPassword(event.password);

    var nicValid = ValidationService.isValidNIC(event.nic);

// Validate confirm password
    var confirmPassValid = ValidationService.isValidConfirmPassword(
        event.password, event.conPassword);

// Validate email
    var emailValid = ValidationService.isValidEmail(event.email);

// Validate date of birth

    var dobValid = ValidationService.isValidDateOfBirth(event.dob);

// Validate first name
    var fNameValid =
        ValidationService.isValidName(event.firstName, NameType.firstName);

// Validate last name
    var lNameValid =
        ValidationService.isValidName(event.lastName, NameType.lastName);

// Validate mobile number
    var mobileValid = event.mobile.isEmpty
        ? const SignupState(
            status: SignUpStatus.failure,
            message: "Mobile number is\nrequired.")
        : !ValidationService.isValidPhoneNumber(event.mobile)
            ? const SignupState(
                status: SignUpStatus.failure,
                message: "Enter valid mobile\nnumber!")
            : null;

// Validate password, confirm password, and other conditions
    if (fNameValid != "valid") {
      emit(SignupState(status: SignUpStatus.failure, message: fNameValid));
    } else if (lNameValid != "valid") {
      emit(SignupState(status: SignUpStatus.failure, message: lNameValid));
    } else if (dobValid != 'valid') {
      emit(SignupState(status: SignUpStatus.failure, message: dobValid));
    } else if (emailValid != 'valid') {
      emit(SignupState(status: SignUpStatus.failure, message: emailValid));
    } else if (mobileValid != null) {
      emit(mobileValid);
    } else if (nicValid != 'valid') {
      emit(SignupState(status: SignUpStatus.failure, message: nicValid));
    } else if (passwordValid != 'valid') {
      emit(SignupState(status: SignUpStatus.failure, message: passwordValid));
    } else if (confirmPassValid != 'valid') {
      emit(
          SignupState(status: SignUpStatus.failure, message: confirmPassValid));
    } else if (!event.isChecked) {
      emit(const SignupState(
          status: SignUpStatus.failure,
          message:
              "Please agree to the terms and\nconditions before continuing."));
    } else {
      email = event.email;
      password = event.password;

      try {
        var response = await AuthRepositories().userSignUpApply(
            fName: event.firstName,
            lName: event.lastName,
            email: event.email,
            mobNo: event.mobile,
            password: event.password,
            nic: event.nic,
            isSocialUser: event.credentials != null ? true : false,
            socialLogin: event.credentials != null
                ? event.credentials!.signInMethod.substring(
                    0,
                    event.credentials!.signInMethod
                        .indexOf(".")) // remove .com from text
                : '',
            socialToken: event.credentials?.accessToken);

        model = response;
        signupButtonEvent = event;
        await createCustomerMethode(response, event);
      } on AuthException catch (e) {
        emit(SignupState(status: SignUpStatus.failure, message: e.message));
      }
    }
  }

  // calling this when apply api success
  Future<void> createCustomerMethode(
      response, SignupButtonPressEvent event) async {
    ApplyResponseModel model = response;

    try {
      await AuthRepositories().createCustomerRepo(
          fName: event.firstName,
          lName: event.lastName,
          email: event.email,
          mobNo: event.mobile,
          dob: event.dob,
          nic: event.nic,
          cUID: model.identityId);

      if (event.credentials != null) {
        await GoogleSigninSevrice()
            .googleSignWithCredentials(credentials: event.credentials);
      }

      emit(SignupActionState(mob: event.mobile));
    } on AuthException catch (e) {
      emit(SignupState(status: SignUpStatus.failure, message: e.message));
    } catch (e) {
      emit(const SignupState(
          status: SignUpStatus.failure, message: "Somthing went wrong!"));
    }

    // var customerResponse = await AuthRepositories().createCustomerRepo(
    //     fName: event.firstName,
    //     lName: event.lastName,
    //     email: event.email,
    //     mobNo: event.mobile,
    //     dob: event.dob,
    //     cUID: model.identityId);

    // switch (customerResponse.runtimeType) {
    //   case int:
    //     emit(const SignupState(
    //         status: SignUpStatus.failure,
    //         message: "Your account already\nexists"));
    //     break;
    //   case String:
    //     emit(const SignupState(
    //         status: SignUpStatus.failure, message: "Somthing went wrong!"));
    //     break;
    //   case CreatedUserModel:
    //     print("user Created -- navigate to OTP");

    //     // save this information on the state

    //     if (event.credentials != null) {
    //       await GoogleSigninSevrice()
    //           .googleSignWithCredentials(credentials: event.credentials);
    //     }

    //     emit(SignupActionState(
    //         createdUserModel: customerResponse as CreatedUserModel));
    //   default:
    // }
  }

  // FutureOr<void> signupActionEvent(
  //     SignupActionEvent event, Emitter<SignupState> emit) {
  //   emit(SignupActionState(
  //     createdUserModel: event.createdUserModel,
  //   ));
  // }

  FutureOr<void> signUpGoogleActionButtonEvent(
      SignUpGoogleActionButtonEvent event, Emitter<SignupState> emit) async {
    emit(const SignupState(status: SignUpStatus.loading));

    UserDataModel? user =
        await GoogleSigninSevrice().googleGetUserData(isLogin: false);

    print("First Name${user!.firstName}");

    if (user.firstName.isNotEmpty) {
      emit(SignUpGoogleDataSuccessState(userDate: user));
    } else {
      emit(const SignupState(
          status: SignUpStatus.failure, message: "Google sign-up\nfailed!"));
    }
  }
}
