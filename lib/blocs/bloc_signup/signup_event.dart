// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupButtonPressEvent extends SignupEvent {
  final String firstName;
  final String lastName;
  final String dob;
  final String email;
  final String mobile;
  final String nic;
  final String password;
  final String conPassword;
  final bool isChecked;
  final AuthCredential? credentials;

  const SignupButtonPressEvent( 
      {required this.firstName,
      required this.lastName,
      required this.dob,
      required this.email,
      required this.mobile,
      required this.nic,
      required this.password,
      required this.conPassword,
      required this.isChecked,
      this.credentials});

  @override
  List<Object> get props => [
        firstName,
        lastName,
        dob,
        email,
        mobile,
        password,
        conPassword,
        isChecked,
        credentials!
      ];
}

class SignupActionEvent extends SignupEvent {
  CreatedUserModel createdUserModel;
  AuthCredential credential;
  SignupActionEvent({
    required this.createdUserModel,
    required this.credential,
  });
  @override
  List<Object> get props => [createdUserModel, credential];
}

class SignUpGoogleActionButtonEvent extends SignupEvent {
  @override
  List<Object> get props => [];
}
