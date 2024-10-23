import 'dart:async';
import 'dart:developer';
import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:app/services/services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpInitial()) {
    on<OtpSendEvent>(otpSendEvent);
    on<OtpSignupResendEvent>(otpSignupResendEvent);
    on<OtpVerifyEvenet>(otpVerifyEvenet);
    on<OtpLoginVerifyEvent>(otpLoginVerifyEvent);
    on<OtpTimerStartEvent>(otpTimerStartEvent);
    on<OtpTimerFinishedEvent>(otpTimerFinishedEvent);
    on<VerifyOtpSuccessEvent>(verifyOtpSuccessEvent);
    on<SignInVerifiedUserEvent>(signInVerifiedUserEvent);
  }

  FutureOr<void> otpSendEvent(
      OtpSendEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    var response =
        await AuthRepositories().sendOtpRepo(username: event.username);

    if (response == 202) {
      emit(OtpTimerStartState());
    } else {
      emit(const OtpErrorState(message: "Otp send failer!"));
    }
  }

  FutureOr<void> otpVerifyEvenet(
      OtpVerifyEvenet event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());

    String validate = ValidationService.isValidOTP('OTP', event.otp);
    if (validate != 'valid') {
      emit(OtpErrorState(message: validate));
    } else {
      var response = await AuthRepositories()
          .verifyOtpRepo(username: event.username, otp: event.otp);

      /// here success response retune id is need to call register complete API..

      if (response == 400) {
        emit(const OtpErrorState(message: "Please enter valid\nOTP"));
      } else {
        EasyLoading.show(status: "Verifying...");

        log("Identity ID :: ${event.applyResponseModel.identityId}");
        log("ID :: ${event.applyResponseModel.id}");

        try {
          await AuthRepositories()
              .userGetIamId(identity: event.applyResponseModel.identityId);

          try {
            await AuthRepositories()
                .userVerify(id: event.applyResponseModel.identityId);

            var authCode = response['result'];
            var selfRegCompleteResponse = await AuthRepositories()
                .selfRegisterConfirmRepo(authCode: authCode);

            if (selfRegCompleteResponse == 201) {
              emit(VerifyOtpSuccessState(authCode: authCode.toString()));
            } else {
              emit(const OtpErrorState(message: "Verification Failed!"));
            }

            log("verifyResponse :: Success");
          } on AuthException {
            log("verifyResponse Faild :: AuthException");
            emit(const OtpErrorState(message: "Verification Failed!"));
          } catch (e) {
            log("verifyResponse Faild $e");
            emit(const OtpErrorState(message: "Verification Failed!"));
          }

          // if (verifyCustomerResponse == 200) {

          // } else {
          //   emit(const OtpErrorState(message: "Verification Failed!"));
          // }
        } on AuthException {
          log("userGetIamId Faild :: AuthException");
          emit(const OtpErrorState(message: "Verification Failed!"));
        } catch (e) {
          log("userGetIamId Faild $e");
          emit(const OtpErrorState(message: "Verification Failed!"));
        }

        // // if (responseCustomerInfo.runtimeType == GetUserByEmailModel) {
        // //   GetUserByEmailModel userByEmailModel = responseCustomerInfo;
        // // var verifyCustomerResponse = await AuthRepositories()
        // //     .verifyCustomerRepo(customerID: userByEmailModel.id);

        // // if (verifyCustomerResponse == 200) {
        // //   var authCode = response['result'];
        // //   var selfRegCompleteResponse = await AuthRepositories()
        // //       .selfRegisterConfirmRepo(authCode: authCode);
        // //   if (selfRegCompleteResponse == 201) {
        // //     emit(VerifyOtpSuccessState(authCode: authCode.toString()));
        // //   } else {
        // //     emit(const OtpErrorState(message: "Verification Failed!"));
        // //   }
        // // } else {
        // //   emit(const OtpErrorState(message: "Verification Failed!"));
        // // }
        // // } else {
        // //   emit(const OtpErrorState(message: "Verification Failed!"));
        // // }
      }
    }
  }

  FutureOr<void> otpTimerFinishedEvent(
      OtpTimerFinishedEvent event, Emitter<OtpState> emit) {
    emit(OtpTimerFinishState());
  }

  FutureOr<void> otpTimerStartEvent(
      OtpTimerStartEvent event, Emitter<OtpState> emit) {
    emit(OtpTimerStartState());
  }

// this is for login user verify
  FutureOr<void> otpLoginVerifyEvent(
      OtpLoginVerifyEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    if (event.otp.isEmpty) {
      emit(const OtpErrorState(message: "Please enter OTP!"));
    } else {
      var response = await AuthRepositories()
          .verifyLoginOtpRepo(mobile: event.mobile, otp: event.otp);
      if (response is String) {
        // otp verified
        emit(VerifyOtpSuccessState(authCode: response));
      } else if (response == 400) {
        // invalid otp submited
        emit(const OtpErrorState(message: "Verification Failed!"));
      } else {
        /// somthing else
        emit(const OtpErrorState(message: "Somthing went wrong!"));
      }
    }
  }

  FutureOr<void> verifyOtpSuccessEvent(
      VerifyOtpSuccessEvent event, Emitter<OtpState> emit) {
    emit(VerifyOtpSuccessState(authCode: event.authCode));
  }

  FutureOr<void> otpSignupResendEvent(
      OtpSignupResendEvent event, Emitter<OtpState> emit) async {
    ApplyResponseModel model = event.model;
    SignupButtonPressEvent newEvent = event.signupButtonPressEvent;
    var customerResponse = await AuthRepositories().createCustomerRepo(
        fName: newEvent.firstName,
        lName: newEvent.lastName,
        email: newEvent.email,
        mobNo: newEvent.mobile,
        nic: newEvent.nic,
        dob: newEvent.dob,
        cUID: model.identityId);

    switch (customerResponse.runtimeType) {
      case const (int):
        emit(const OtpErrorState(message: "Your account already\nexists"));
        break;
      case const (String):
        emit(const OtpErrorState(message: "Somthing went wrong!"));
        break;
      case const (CreatedUserModel):
        if (newEvent.credentials != null) {
          await GoogleSigninSevrice()
              .googleSignWithCredentials(credentials: newEvent.credentials);
        }
        emit(OtpTimerStartState());
      default:
    }
  }

  FutureOr<void> signInVerifiedUserEvent(
      SignInVerifiedUserEvent event, Emitter<OtpState> emit) async {
    String email = event.email;
    String pass = event.pass;

    // post user data
    var response =
        await AuthRepositories().userSignIn(email: email, pass: pass);

    // handle response
    if (response.runtimeType == UserLoginModel) {
      response as UserLoginModel;

      final userPreferences =
          UserPreferencesRepository(await SharedPreferences.getInstance());

      userPreferences.saveUser(response);

      emit(AutomaticSignInSuccessState(
          identityId: response.loggedUser.identityId));
    } else {
      // emit(OtpErrorState(message: "Automatic sign-in failed.\nPlease sign in manually."));
      emit(AutomaticSignInFaillState());
    }
  }
}
