import 'dart:convert';

List<BannersModel> bannersModelFromJson(String str) => List<BannersModel>.from(
    json.decode(str).map((x) => BannersModel.fromJson(x)));

String bannersModelToJson(List<BannersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannersModel {
  final String id;
  final String bannerType;
  final String bannerImageUrl;
  final String bannerDescription;
  final DateTime activeFrom;
  final DateTime activeTo;
  final Promotion? promotion;
  final Shop? shop;

  BannersModel({
    required this.id,
    required this.bannerType,
    required this.bannerImageUrl,
    required this.bannerDescription,
    required this.activeFrom,
    required this.activeTo,
    this.promotion,
    this.shop,
  });

  factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
        id: json["id"],
        bannerType: json["bannerType"],
        bannerImageUrl: json["bannerImageUrl"],
        bannerDescription: json["bannerDescription"],
        activeFrom: DateTime.parse(json["activeFrom"]),
        activeTo: DateTime.parse(json["activeTo"]),
        promotion: json["promotion"] == null
            ? null
            : Promotion.fromJson(json["promotion"]),
        shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bannerType": bannerType,
        "bannerImageUrl": bannerImageUrl,
        "bannerDescription": bannerDescription,
        "activeFrom": activeFrom.toIso8601String(),
        "activeTo": activeTo.toIso8601String(),
        "promotion": promotion?.toJson(),
        "shop": shop?.toJson(),
      };
}

class Promotion {
  final String id;
  final String promotionName;

  Promotion({
    required this.id,
    required this.promotionName,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json["id"],
        promotionName: json["promotionName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "promotionName": promotionName,
      };
}

class Shop {
  final String id;

  Shop({
    required this.id,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
