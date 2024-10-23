import 'dart:convert';

IamUserModel iamUserModelFromJson(String str) =>
    IamUserModel.fromJson(json.decode(str));

String iamUserModelToJson(IamUserModel data) => json.encode(data.toJson());

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(IamUserModel data) => json.encode(data.toJson());

class IamUserModel {
  final dynamic ageVerified;
  final DateTime dob;
  final String email;
  final String firstName;
  final dynamic gender;
  final String id;
  final String lastName;
  final String mobile;
  final String nic;
  final dynamic passport;
  final dynamic passportUrl;
  final dynamic driverLicense;
  final dynamic driverLicenseUrl;
  final dynamic nicBackFileUrl;
  final dynamic nicFrontFileUrl;
  final String profilePictureUrl;
  final List<Address> addressList;

  IamUserModel({
    required this.ageVerified,
    required this.dob,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.id,
    required this.lastName,
    required this.mobile,
    required this.nic,
    required this.passport,
    required this.passportUrl,
    required this.driverLicense,
    required this.driverLicenseUrl,
    required this.nicBackFileUrl,
    required this.nicFrontFileUrl,
    required this.profilePictureUrl,
    required this.addressList,
  });

  factory IamUserModel.fromJson(Map<String, dynamic> json) => IamUserModel(
        ageVerified: json["ageVerified"],
        dob: DateTime.parse(json["dob"]),
        email: json["email"] ?? "",
        firstName: json["firstName"] ?? "",
        gender: json["gender"],
        id: json["id"] ?? "",
        lastName: json["lastName"] ?? "",
        mobile: json["mobile"] ?? "",
        nic: json["nic"] ?? '',
        passport: json["passport"],
        passportUrl: json["passportUrl"],
        driverLicense: json["driverLicense"],
        driverLicenseUrl: json["driverLicenseUrl"],
        nicBackFileUrl: json["nicBackFileUrl"],
        nicFrontFileUrl: json["nicFrontFileUrl"],
        profilePictureUrl: json["profilePictureUrl"] ?? '',
        addressList: List<Address>.from(
            json["addressList"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ageVerified": ageVerified,
        "dob": dob.toIso8601String(),
        "email": email,
        "firstName": firstName,
        "gender": gender,
        "id": id,
        "lastName": lastName,
        "mobile": mobile,
        "nic": nic,
        "passport": passport,
        "passportUrl": passportUrl,
        "driverLicense": driverLicense,
        "driverLicenseUrl": driverLicenseUrl,
        "nicBackFileUrl": nicBackFileUrl,
        "nicFrontFileUrl": nicFrontFileUrl,
        "profilePictureUrl": profilePictureUrl,
        "addressList": List<dynamic>.from(addressList.map((x) => x.toJson())),
      };
}

class Address {
  final String addressLine1;
  final String addressLine2;
  final String addressLine3;
  final String bldName;
  final String bldNo;
  final String city;
  final DateTime created;
  final String district;
  final String id;
  final double latitude;
  final double longitude;
  final String nickname;
  final String postalCode;
  final String province;
  final DateTime updated;
  final bool isDefault;

  Address({
    required this.addressLine1,
    required this.addressLine2,
    required this.addressLine3,
    required this.bldName,
    required this.bldNo,
    required this.city,
    required this.created,
    required this.district,
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.nickname,
    required this.postalCode,
    required this.province,
    required this.updated,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        addressLine3: json["addressLine3"],
        bldName: json["bldName"],
        bldNo: json["bldNo"],
        city: json["city"],
        created: DateTime.parse(json["created"]),
        district: json["district"],
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        nickname: json["nickname"],
        postalCode: json["postalCode"],
        province: json["province"],
        updated: DateTime.parse(json["updated"]),
        isDefault: json["isDefault"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "addressLine3": addressLine3,
        "bldName": bldName,
        "bldNo": bldNo,
        "city": city,
        "created": created.toIso8601String(),
        "district": district,
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "nickname": nickname,
        "postalCode": postalCode,
        "province": province,
        "updated": updated.toIso8601String(),
        "isDefault": isDefault,
      };
}
