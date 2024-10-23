import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) =>
    UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
  String accessToken;
  String refreshToken;
  LoggedUser loggedUser;
  dynamic authorizationCode;

  UserLoginModel({
    required this.accessToken,
    required this.refreshToken,
    required this.loggedUser,
    required this.authorizationCode,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        loggedUser: LoggedUser.fromJson(json["loggedUser"]),
        authorizationCode: json["authorizationCode"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "loggedUser": loggedUser.toJson(),
        "authorizationCode": authorizationCode,
      };
}

class LoggedUser {
  int id;
  String identityId;
  String firstName;
  String lastName;
  String email;
  String mobileNo;
  String type;
  dynamic vendor;
  List<Role> roles;
  bool status;
  dynamic resetPassword;

  LoggedUser({
    required this.id,
    required this.identityId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNo,
    required this.type,
    required this.vendor,
    required this.roles,
    required this.status,
    required this.resetPassword,
  });

  factory LoggedUser.fromJson(Map<String, dynamic> json) => LoggedUser(
        id: json["id"],
        identityId: json["identityId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        mobileNo: json["mobileNo"],
        type: json["type"],
        vendor: json["vendor"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        status: json["status"],
        resetPassword: json["resetPassword"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identityId": identityId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "mobileNo": mobileNo,
        "type": type,
        "vendor": vendor,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "status": status,
        "resetPassword": resetPassword,
      };
}

class Role {
  final dynamic lastModifiedDate;
  final dynamic createdDate;
  final String identityId;
  final String name;
  final String type;
  final String description;
  final dynamic permissions;

  Role({
    required this.lastModifiedDate,
    required this.createdDate,
    required this.identityId,
    required this.name,
    required this.type,
    required this.description,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        lastModifiedDate: json["lastModifiedDate"],
        createdDate: json["createdDate"],
        identityId: json["identityId"],
        name: json["name"],
        type: json["type"],
        description: json["description"],
        permissions: json["permissions"],
      );

  Map<String, dynamic> toJson() => {
        "lastModifiedDate": lastModifiedDate,
        "createdDate": createdDate,
        "identityId": identityId,
        "name": name,
        "type": type,
        "description": description,
        "permissions": permissions,
      };
}
