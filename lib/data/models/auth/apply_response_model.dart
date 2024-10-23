import 'dart:convert';

ApplyResponseModel applyResponseModelFromJson(String str) =>
    ApplyResponseModel.fromJson(json.decode(str));

String applyResponseModelToJson(ApplyResponseModel data) =>
    json.encode(data.toJson());

class ApplyResponseModel {
  final int id;
  final String identityId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNo;
  final String type;
  final dynamic vendor;
  final dynamic roles;
  final bool status;
  final dynamic resetPassword;

  ApplyResponseModel({
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

  factory ApplyResponseModel.fromJson(Map<String, dynamic> json) =>
      ApplyResponseModel(
        id: json["id"],
        identityId: json["identityId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        mobileNo: json["mobileNo"],
        type: json["type"],
        vendor: json["vendor"],
        roles: json["roles"],
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
        "roles": roles,
        "status": status,
        "resetPassword": resetPassword,
      };
}
