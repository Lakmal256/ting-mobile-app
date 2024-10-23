import 'dart:convert';

// Function to parse JSON string into VendorProfileModel
VendorProfileModel vendorProfileModelFromJson(String str) =>
    VendorProfileModel.fromJson(json.decode(str));

// Function to convert VendorProfileModel to JSON string
String vendorProfileModelToJson(VendorProfileModel data) =>
    json.encode(data.toJson());

// Model class for VendorProfile
class VendorProfileModel {
  final String id;
  final String name;
  final String cardLabel;
  final List<String> categories;
  final String address;
  final List<OpenHour> openHours;
  final dynamic rating;
  final dynamic ratingPct;
  final dynamic votes;
  final String distance;
  final String coverImageUrl;

  VendorProfileModel({
    required this.id,
    required this.name,
    required this.cardLabel,
    required this.categories,
    required this.address,
    required this.openHours,
    this.rating,
    this.ratingPct,
    this.votes,
    required this.distance,
    required this.coverImageUrl,
  });

  // Factory constructor to create VendorProfileModel from JSON map
  factory VendorProfileModel.fromJson(Map<String, dynamic> json) =>
      VendorProfileModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        cardLabel: json["cardLabel"] ?? '',
        categories:
            List<String>.from(json["categories"].map((x) => x as String)),
        address: json["address"] ?? '',
        openHours: List<OpenHour>.from(
            json["openHours"].map((x) => OpenHour.fromJson(x))),
        rating: json["rating"],
        ratingPct: json["ratingPct"],
        votes: json["votes"],
        distance: json["distance"] ?? '',
        coverImageUrl: json["coverImageUrl"] ?? '',
      );

  // Method to convert VendorProfileModel to JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cardLabel": cardLabel,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "address": address,
        "openHours": List<dynamic>.from(openHours.map((x) => x.toJson())),
        "rating": rating,
        "ratingPct": ratingPct,
        "votes": votes,
        "distance": distance,
        "coverImageUrl": coverImageUrl,
      };
}

// Model class for OpenHour
class OpenHour {
  final String dayOfWeek;
  final bool closed;
  final String startTime;
  final String endTime;

  OpenHour({
    required this.dayOfWeek,
    required this.closed,
    required this.startTime,
    required this.endTime,
  });

  // Factory constructor to create OpenHour from JSON map
  factory OpenHour.fromJson(Map<String, dynamic> json) => OpenHour(
        dayOfWeek: json["dayOfWeek"] ?? '',
        closed: json["closed"] ?? false,
        startTime: json["startTime"] ?? '',
        endTime: json["endTime"] ?? '',
      );

  // Method to convert OpenHour to JSON map
  Map<String, dynamic> toJson() => {
        "dayOfWeek": dayOfWeek,
        "closed": closed,
        "startTime": startTime,
        "endTime": endTime,
      };
}
