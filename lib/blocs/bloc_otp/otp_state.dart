part of 'otp_bloc.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

final class OtpInitial extends OtpState {
  @override
  List<Object> get props => [];
}

class OtpLoadingState extends OtpState {
  @override
  List<Object> get props => [];
}

class OtpErrorState extends OtpState {
  final String message;

  const OtpErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class OtpSuccessState extends OtpState {
  final String message;

  const OtpSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class OtpTimerStartState extends OtpState {
  @override
  List<Object> get props => [];
}

class OtpTimerFinishState extends OtpState {
  @override
  List<Object> get props => [];
}

class VerifyOtpSuccessState extends OtpState {
  final String authCode;

  const VerifyOtpSuccessState({required this.authCode});
  @override
  List<Object> get props => [authCode];
}

class AutomaticSignInSuccessState extends OtpState {
  final String identityId;

  const AutomaticSignInSuccessState({required this.identityId});
}

class AutomaticSignInFaillState extends OtpState {}


