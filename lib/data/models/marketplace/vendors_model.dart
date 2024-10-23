import 'dart:convert';

List<VendorsModel> vendorsModelFromJson(String str) => List<VendorsModel>.from(
    json.decode(str).map((x) => VendorsModel.fromJson(x)));

String vendorsModelToJson(List<VendorsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorsModel {
  final String id;
  final String name;
  final dynamic prepareTime;
  final dynamic deliveryTime;
  final String bannerImage;
  final dynamic cardLabel;
  final bool open;
  final bool enabled;
  final double latitude;
  final double longitude;
  final dynamic rating;
  final dynamic ratingPct;
  final dynamic votes;
  final bool isRecommended;
  final bool isFeatured;
  final dynamic priceRange;
  final bool isVegan;
  final bool isGluten;
  final bool isVegetarian;
  final bool isHalal;
  final String distance;
  final dynamic deliveryFee;
  final String deliveryFeeCurrency;
  final bool multipleOffers;
  final List<VendorCategory> vendorCategories;

  VendorsModel({
    required this.id,
    required this.name,
    required this.prepareTime,
    required this.deliveryTime,
    required this.bannerImage,
    required this.cardLabel,
    required this.open,
    required this.enabled,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.ratingPct,
    required this.votes,
    required this.isRecommended,
    required this.isFeatured,
    required this.priceRange,
    required this.isVegan,
    required this.isGluten,
    required this.isVegetarian,
    required this.isHalal,
    required this.deliveryFee,
    required this.deliveryFeeCurrency,
    required this.distance,
    required this.multipleOffers,
    required this.vendorCategories,
  });

  factory VendorsModel.fromJson(Map<String, dynamic> json) => VendorsModel(
        id: json["id"],
        name: json["name"],
        prepareTime: json["prepareTime"],
        deliveryTime: json["deliveryTime"],
        bannerImage: json["bannerImage"] ?? '',
        cardLabel: json["cardLabel"],
        open: json["open"],
        enabled: json["enabled"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        rating: json["rating"],
        ratingPct: json["ratingPct"],
        votes: json["votes"],
        isRecommended: json["isRecommended"],
        isFeatured: json["isFeatured"] ?? false,
        priceRange: json["priceRange"],
        isVegan: json["isVegan"],
        isGluten: json["isGluten"],
        isVegetarian: json["isVegetarian"],
        isHalal: json["isHalal"],
        distance: json["distance"] ?? '',
        deliveryFee: json["deliveryFee"] ?? '',
        deliveryFeeCurrency: json["deliveryFeeCurrency"] ?? '',
        multipleOffers: json["multipleOffers"] ?? '',
        vendorCategories: json["vendorCategories"] != null
            ? List<VendorCategory>.from(
                json["vendorCategories"].map((x) => VendorCategory.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        'prepareTime': prepareTime,
        "deliveryTime": deliveryTime,
        "bannerImage": bannerImage,
        "cardLabel": cardLabel,
        "open": open,
        "enabled": enabled,
        "latitude": latitude,
        "longitude": longitude,
        "rating": rating,
        "ratingPct": ratingPct,
        "votes": votes,
        "isRecommended": isRecommended,
        "isFeatured": isFeatured,
        "priceRange": priceRange,
        "isVegan": isVegan,
        "isGluten": isGluten,
        "isVegetarian": isVegetarian,
        "isHalal": isHalal,
        "distance": distance,
        'deliveryFee': deliveryFee,
        'deliveryFeeCurrency': deliveryFeeCurrency,
        'multipleOffers': multipleOffers,
        "vendorCategories":
            List<dynamic>.from(vendorCategories.map((x) => x.toJson())),
      };
}

class VendorCategory {
  final String id;
  final String name;

  VendorCategory({
    required this.id,
    required this.name,
  });

  factory VendorCategory.fromJson(Map<String, dynamic> json) => VendorCategory(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
