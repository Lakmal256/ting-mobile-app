// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'signup_bloc.dart';

enum SignUpStatus {
  success,
  failure,
  loading,
}

class SignupState extends Equatable {
  final String firstName;
  final String lastName;
  final String dob;
  final String email;
  final String mobile;
  final String message;
  final SignUpStatus status;

  const SignupState(
      {this.firstName = '',
      this.lastName = '',
      this.dob = '',
      this.email = '',
      this.mobile = '',
      this.message = '',
      this.status = SignUpStatus.loading});

  SignupState copyWith({
    String? firstName,
    String? lastName,
    String? dob,
    String? email,
    String? mobile,
    String? message,
    SignUpStatus? status,
  }) {
    return SignupState(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dob: dob ?? this.dob,
        email: email ?? this.email,
        message: message ?? this.message,
        mobile: mobile ?? this.mobile,
        status: status ?? this.status);
  }

  @override
  List<Object> get props =>
      [firstName, lastName, dob, email, mobile, message, status];
}

class SignupActionState extends SignupState {
  String mob;
  SignupActionState({
    required this.mob,
  });
  @override
  List<Object> get props => [mob];
}

class SignUpGoogleDataSuccessState extends SignupState {
  final UserDataModel userDate;

  const SignUpGoogleDataSuccessState({required this.userDate});

  @override
  List<Object> get props => [userDate];
}
