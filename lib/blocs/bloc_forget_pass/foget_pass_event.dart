part of 'foget_pass_bloc.dart';

sealed class FogetPassEvent extends Equatable {
  const FogetPassEvent();

  @override
  List<Object> get props => [];
}

abstract class ForgetPassActionEvent extends FogetPassEvent {}

class GetOtpEvent extends ForgetPassActionEvent {
  final String mobileNumber;

  GetOtpEvent({required this.mobileNumber});

  @override
  List<Object> get props => [mobileNumber];
}

class GetOtpSuccessEvent extends ForgetPassActionEvent {
  @override
  List<Object> get props => [];
}
