import 'dart:convert';

ProductsModel productsModelFromJson(String str) =>
    ProductsModel.fromJson(json.decode(str));

String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
  final int count;
  final List<ProductItem> productList;

  ProductsModel({required this.count, required this.productList});

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        count: json["count"] ?? 0,
        productList: json["productList"] == null
            ? []
            : List<ProductItem>.from(
                json["productList"].map((x) => ProductItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "productList": List<dynamic>.from(productList.map((x) => x.toJson())),
      };
}

class ProductItem {
  final String id;
  final int availableQty;
  final DateTime createdOn;
  final String displayName;
  final bool enabled;
  final bool deleted;
  final String longDescription;
  final bool noVolumeItem;
  final bool noWeightItem;
  final int prepareTime;
  final bool priorityDeliveryItem;
  final String shippingVehicle;
  final String shortDescription;
  final String skuCode;
  final String skuName;
  final bool stockStatus;
  final String uom;
  final DateTime updatedOn;
  final String visibility;
  final int volume;
  final int weight;
  final int price;
  final List<dynamic> mediaList;
  final List<AttributeList> attributeList;
  final List<CategoryList> categoryList;

  ProductItem({
    required this.id,
    required this.availableQty,
    required this.createdOn,
    required this.displayName,
    required this.enabled,
    required this.deleted,
    required this.longDescription,
    required this.noVolumeItem,
    required this.noWeightItem,
    required this.prepareTime,
    required this.priorityDeliveryItem,
    required this.shippingVehicle,
    required this.shortDescription,
    required this.skuCode,
    required this.skuName,
    required this.stockStatus,
    required this.uom,
    required this.updatedOn,
    required this.visibility,
    required this.volume,
    required this.weight,
    required this.price,
    required this.mediaList,
    required this.attributeList,
    required this.categoryList,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        id: json["id"],
        availableQty: json["availableQty"],
        createdOn: json["createdOn"] != null
            ? DateTime.parse(json["createdOn"])
            : DateTime(0),
        displayName: json["displayName"],
        enabled: json["enabled"],
        deleted: json["deleted"],
        longDescription: json["longDescription"],
        noVolumeItem: json["noVolumeItem"] ?? 0,
        noWeightItem: json["noWeightItem"] ?? 0,
        prepareTime: json["prepareTime"],
        priorityDeliveryItem: json["priorityDeliveryItem"],
        shippingVehicle: json["shippingVehicle"],
        shortDescription: json["shortDescription"],
        skuCode: json["skuCode"],
        skuName: json["skuName"],
        stockStatus: json["stockStatus"],
        uom: json["uom"],
        updatedOn: json["updatedOn"] != null
            ? DateTime.parse(json["updatedOn"])
            : DateTime(0),
        visibility: json["visibility"],
        volume: json["volume"] ?? 0,
        weight: json["weight"] ?? 0,
        price: json["price"] ?? 0,
        mediaList: List<dynamic>.from(json["mediaList"].map((x) => x)),
        attributeList: List<AttributeList>.from(
            json["attributeList"].map((x) => AttributeList.fromJson(x))),
        categoryList: List<CategoryList>.from(
            json["categoryList"].map((x) => CategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "availableQty": availableQty,
        "createdOn": createdOn.toIso8601String(),
        "displayName": displayName,
        "enabled": enabled,
        "deleted": deleted,
        "longDescription": longDescription,
        "noVolumeItem": noVolumeItem,
        "noWeightItem": noWeightItem,
        "prepareTime": prepareTime,
        "priorityDeliveryItem": priorityDeliveryItem,
        "shippingVehicle": shippingVehicle,
        "shortDescription": shortDescription,
        "skuCode": skuCode,
        "skuName": skuName,
        "stockStatus": stockStatus,
        "uom": uom,
        "updatedOn": updatedOn.toIso8601String(),
        "visibility": visibility,
        "volume": volume,
        "weight": weight,
        "price": price,
        "mediaList": List<dynamic>.from(mediaList.map((x) => x)),
        "attributeList":
            List<dynamic>.from(attributeList.map((x) => x.toJson())),
        "categoryList": List<dynamic>.from(categoryList.map((x) => x.toJson())),
      };
}

class AttributeList {
  final Attribute attribute;
  final String value;
  final String id;

  AttributeList({
    required this.attribute,
    required this.value,
    required this.id,
  });

  factory AttributeList.fromJson(Map<String, dynamic> json) => AttributeList(
        attribute: Attribute.fromJson(json["attribute"]),
        value: json["value"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "attribute": attribute.toJson(),
        "value": value,
        "id": id,
      };
}

class Attribute {
  final String dataType;
  final String defaultValue;
  final String description;
  final String name;
  final dynamic parent;
  final String type;
  final String id;

  Attribute({
    required this.dataType,
    required this.defaultValue,
    required this.description,
    required this.name,
    required this.parent,
    required this.type,
    required this.id,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        dataType: json["dataType"],
        defaultValue: json["defaultValue"],
        description: json["description"],
        name: json["name"],
        parent: json["parent"],
        type: json["type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "dataType": dataType,
        "defaultValue": defaultValue,
        "description": description,
        "name": name,
        "parent": parent,
        "type": type,
        "id": id,
      };
}

class CategoryList {
  final String id;
  final Category category;
  final dynamic value;

  CategoryList({
    required this.id,
    required this.category,
    required this.value,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        category: Category.fromJson(json["category"]),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category.toJson(),
        "value": value,
      };
}

class Category {
  final String id;
  final String name;
  final String description;
  final String type;
  final String imageUrl;
  final dynamic parent;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.imageUrl,
    required this.parent,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        type: json["type"],
        imageUrl: json["imageUrl"],
        parent: json["parent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "type": type,
        "imageUrl": imageUrl,
        "parent": parent,
      };
}
