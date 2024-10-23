part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressedEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressedEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class GoogleSigninButtonPressEvent extends LoginEvent {
  final String token;

  const GoogleSigninButtonPressEvent({required this.token});
  @override
  List<Object> get props => [token];
}

class CheckLoggedInEvent extends LoginEvent {}
