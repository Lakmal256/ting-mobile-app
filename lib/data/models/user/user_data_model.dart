import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UserDataModel {
  final String firstName;
  final String lastName;
  final String email;
  final AuthCredential credentials;

  UserDataModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.credentials});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'credentials': credentials,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      credentials: map['credentials'] as AuthCredential,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
