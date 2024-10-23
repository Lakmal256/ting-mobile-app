import 'dart:convert';

List<CategorizedProductModel> categorizedProductModelFromJson(String str) =>
    List<CategorizedProductModel>.from(
        json.decode(str).map((x) => CategorizedProductModel.fromJson(x)));

String categorizedProductModelToJson(List<CategorizedProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategorizedProductModel {
  final String category;
  final List<Product> productList;

  CategorizedProductModel({
    required this.category,
    required this.productList,
  });

  factory CategorizedProductModel.fromJson(Map<String, dynamic> json) =>
      CategorizedProductModel(
        category: json["category"],
        productList: List<Product>.from(
            json["productList"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "productList": List<dynamic>.from(productList.map((x) => x.toJson())),
      };
}

class Product {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String skuCode;
  final String skuName;
  final String displayName;
  final String shortDescription;
  final String longDescription;
  final String uom;
  final int weight;
  final bool noWeightItem;
  final int volume;
  final bool noVolumeItem;
  final String shippingVehicle;
  final bool priorityDeliveryItem;
  final int prepareTime;
  final bool stockStatus;
  final int availableQty;
  final String visibility;
  final bool enabled;
  final bool deleted;
  final bool recomended;
  final int deliveryTime;
  final dynamic rating;
  final dynamic cost;
  final bool popular;

  Product({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.skuCode,
    required this.skuName,
    required this.displayName,
    required this.shortDescription,
    required this.longDescription,
    required this.uom,
    required this.weight,
    required this.noWeightItem,
    required this.volume,
    required this.noVolumeItem,
    required this.shippingVehicle,
    required this.priorityDeliveryItem,
    required this.prepareTime,
    required this.stockStatus,
    required this.availableQty,
    required this.visibility,
    required this.enabled,
    required this.deleted,
    required this.recomended,
    required this.deliveryTime,
    required this.rating,
    required this.cost,
    required this.popular,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime(0),
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : DateTime(0),
        skuCode: json["skuCode"],
        skuName: json["skuName"],
        displayName: json["displayName"],
        shortDescription: json["shortDescription"],
        longDescription: json["longDescription"],
        uom: json["uom"],
        weight: json["weight"] ?? 0,
        noWeightItem: json["noWeightItem"],
        volume: json["volume"] ?? 0,
        noVolumeItem: json["noVolumeItem"],
        shippingVehicle: json["shippingVehicle"],
        priorityDeliveryItem: json["priorityDeliveryItem"],
        prepareTime: json["prepareTime"] ?? 0,
        stockStatus: json["stockStatus"],
        availableQty: json["availableQty"],
        visibility: json["visibility"],
        enabled: json["enabled"],
        deleted: json["deleted"],
        recomended: json["recomended"],
        deliveryTime: json["deliveryTime"] ?? 0,
        rating: json["rating"],
        cost: json["cost"],
        popular: json["popular"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "skuCode": skuCode,
        "skuName": skuName,
        "displayName": displayName,
        "shortDescription": shortDescription,
        "longDescription": longDescription,
        "uom": uom,
        "weight": weight,
        "noWeightItem": noWeightItem,
        "volume": volume,
        "noVolumeItem": noVolumeItem,
        "shippingVehicle": shippingVehicle,
        "priorityDeliveryItem": priorityDeliveryItem,
        "prepareTime": prepareTime,
        "stockStatus": stockStatus,
        "availableQty": availableQty,
        "visibility": visibility,
        "enabled": enabled,
        "deleted": deleted,
        "recomended": recomended,
        "deliveryTime": deliveryTime,
        "rating": rating,
        "cost": cost,
        "popular": popular,
      };
}
