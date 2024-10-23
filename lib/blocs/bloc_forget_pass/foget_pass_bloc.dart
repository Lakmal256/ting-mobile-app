import 'dart:async';

import 'package:app/data/repositories/auth_repositories.dart';
import 'package:app/services/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'foget_pass_event.dart';
part 'foget_pass_state.dart';

class ForgetPassBloc extends Bloc<FogetPassEvent, ForgetPassState> {
  ForgetPassBloc() : super(const ForgetPassState()) {
    on<GetOtpEvent>(getOtpEvent);
    on<GetOtpSuccessEvent>(getOtpSuccessEvent);
  }

  FutureOr<void> getOtpEvent(
      GetOtpEvent event, Emitter<ForgetPassState> emit) async {
    emit(const ForgetPasswordLoadingState());
    var mobileValid = ValidationService.isValidPhoneNumber(event.mobileNumber);

    if (event.mobileNumber.isEmpty) {
      emit(const ForgetPasswordErrorState(
          message: "Mobile number is required.!"));
    } else if (!mobileValid) {
      emit(const ForgetPasswordErrorState(
          message: "Enter valid mobile number!"));
    } else {
      var response =
          await AuthRepositories().sendLoginOtpRepo(mobile: event.mobileNumber);
      if (response == 202) {
        emit(GetOtpSuccessState());
      } else {
        emit(const ForgetPasswordErrorState(message: "Somthing went wrong!"));
      }
    }
  }

  FutureOr<void> getOtpSuccessEvent(
      GetOtpSuccessEvent event, Emitter<ForgetPassState> emit) {
    emit(GetOtpSuccessState());
  }
}
