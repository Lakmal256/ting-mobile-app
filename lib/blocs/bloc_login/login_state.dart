part of 'login_bloc.dart';

enum LoginStatus {
  success,
  failure,
  loading,
  notLoggedIn,
}

class LoginState extends Equatable {
  final String message;
  final LoginStatus status;
  final String email;
  final String password;

  const LoginState({
    this.message = '',
    this.status = LoginStatus.loading,
    this.email = '',
    this.password = '',
  });

  LoginState copyWith({
    String? message,
    LoginStatus? status,
    String? email,
    String? password,
  }) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        message: message ?? this.message,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [message, status, email, password];
}
