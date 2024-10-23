// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class OtpSendEvent extends OtpEvent {
  final String username;

  const OtpSendEvent({required this.username});
  @override
  List<Object> get props => [username];
}

class OtpSignupResendEvent extends OtpEvent {
  final ApplyResponseModel model;
  final SignupButtonPressEvent signupButtonPressEvent;
  const OtpSignupResendEvent({
    required this.model,
    required this.signupButtonPressEvent,
  });

  @override
  List<Object> get props => [model, signupButtonPressEvent];
}

class OtpLoginVerifyEvent extends OtpEvent {
  final String mobile;
  final String otp;

  const OtpLoginVerifyEvent({required this.mobile, required this.otp});
  @override
  List<Object> get props => [mobile, otp];
}

class OtpVerifyEvenet extends OtpEvent {
  final String username;
  final String otp;
  final ApplyResponseModel applyResponseModel;

  const OtpVerifyEvenet({required this.username, required this.otp, required this.applyResponseModel});
  @override
  List<Object> get props => [username, otp, applyResponseModel];
}

class OtpTimerStartEvent extends OtpEvent {
  @override
  List<Object> get props => [];
}

class OtpTimerFinishedEvent extends OtpEvent {
  @override
  List<Object> get props => [];
}

class VerifyOtpSuccessEvent extends OtpEvent {
  final String authCode;

  const VerifyOtpSuccessEvent({required this.authCode});
  @override
  List<Object> get props => [];
}

class SignInVerifiedUserEvent extends OtpEvent {
  final String email;
  final String pass;

  const SignInVerifiedUserEvent({required this.email, required this.pass});
}
