part of 'foget_pass_bloc.dart';

class ForgetPassState extends Equatable {
  const ForgetPassState();

  @override
  List<Object> get props => [];
}

class ForgetPasswordLoadingState extends ForgetPassState {
  const ForgetPasswordLoadingState();
  @override
  List<Object> get props => [];
}

class ForgetPasswordErrorState extends ForgetPassState {
  final String message;

  const ForgetPasswordErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class ForgetPasswordSuccessState extends ForgetPassState {
  final String message;

  const ForgetPasswordSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class GetOtpPressState extends ForgetPassState {
  final String mobileNumber;

  const GetOtpPressState({required this.mobileNumber});

  @override
  List<Object> get props => [mobileNumber];
}

class GetOtpSuccessState extends ForgetPassState {
  @override
  List<Object> get props => [];
}
