import 'dart:convert';

CreatedUserModel createdUserModelFromJson(String str) =>
    CreatedUserModel.fromJson(json.decode(str));

String createdUserModelToJson(CreatedUserModel data) =>
    json.encode(data.toJson());

class CreatedUserModel {
  final DateTime createdOn;
  final String customerUserId;
  final bool deleted;
  final bool disabled;
  final DateTime dob;
  final String email;
  final String firstName;
  final dynamic gender;
  final String id;
  final String lastName;
  final String mobile;
  final dynamic nic;
  final dynamic nicFileUrl;
  final String registerMode;
  final bool verified;
  final List<dynamic> addresses;
  final List<dynamic> categoryList;
  final List<dynamic> attributeList;

  CreatedUserModel({
    required this.createdOn,
    required this.customerUserId,
    required this.deleted,
    required this.disabled,
    required this.dob,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.id,
    required this.lastName,
    required this.mobile,
    required this.nic,
    required this.nicFileUrl,
    required this.registerMode,
    required this.verified,
    required this.addresses,
    required this.categoryList,
    required this.attributeList,
  });

  factory CreatedUserModel.fromJson(Map<String, dynamic> json) =>
      CreatedUserModel(
        createdOn: DateTime.parse(json["createdOn"]),
        customerUserId: json["customerUserId"],
        deleted: json["deleted"],
        disabled: json["disabled"],
        dob: DateTime.parse(json["dob"]),
        email: json["email"],
        firstName: json["firstName"],
        gender: json["gender"],
        id: json["id"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        nic: json["nic"],
        nicFileUrl: json["nicFileUrl"],
        registerMode: json["registerMode"],
        verified: json["verified"],
        addresses: List<dynamic>.from(json["addresses"].map((x) => x)),
        categoryList: List<dynamic>.from(json["categoryList"].map((x) => x)),
        attributeList: List<dynamic>.from(json["attributeList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "createdOn": createdOn.toIso8601String(),
        "customerUserId": customerUserId,
        "deleted": deleted,
        "disabled": disabled,
        "dob": dob.toIso8601String(),
        "email": email,
        "firstName": firstName,
        "gender": gender,
        "id": id,
        "lastName": lastName,
        "mobile": mobile,
        "nic": nic,
        "nicFileUrl": nicFileUrl,
        "registerMode": registerMode,
        "verified": verified,
        "addresses": List<dynamic>.from(addresses.map((x) => x)),
        "categoryList": List<dynamic>.from(categoryList.map((x) => x)),
        "attributeList": List<dynamic>.from(attributeList.map((x) => x)),
      };
}
