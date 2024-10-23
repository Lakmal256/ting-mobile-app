import 'dart:convert';

CartResModel cartResModelFromJson(String str) =>
    CartResModel.fromJson(json.decode(str));

String cartResModelToJson(CartResModel data) => json.encode(data.toJson());

class CartResModel {
  final String id;
  final DateTime cartDate;
  final String instructions;
  final String currency;
  final List<Item> items;
  final int value;

  CartResModel({
    required this.id,
    required this.cartDate,
    required this.instructions,
    required this.currency,
    required this.items,
    required this.value,
  });

  CartResModel copyWith({
    String? id,
    DateTime? cartDate,
    String? instructions,
    String? currency,
    List<Item>? items,
    int? value,
  }) {
    return CartResModel(
      id: id ?? this.id,
      cartDate: cartDate ?? this.cartDate,
      instructions: instructions ?? this.instructions,
      currency: currency ?? this.currency,
      items: items ?? this.items,
      value: value ?? this.value,
    );
  }

  factory CartResModel.fromJson(Map<String, dynamic> json) => CartResModel(
        id: json["id"],
        cartDate: DateTime.parse(json["cartDate"]),
        instructions: json["instructions"] ?? "",
        currency: json["currency"] ?? "",
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cartDate": cartDate.toIso8601String(),
        "instructions": instructions,
        "currency": currency,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "value": value,
      };
}

class Item {
  final String lineId;
  final String productId;
  final String productName;
  final int price;
  final int qty;
  final bool isFreeItem;
  final String instructions;
  final String shopId;
  final List<ItemCustomization> customizations;

  Item({
    required this.lineId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.qty,
    required this.isFreeItem,
    required this.instructions,
    required this.shopId,
    required this.customizations,
  });

  Item copyWith({
    String? lineId,
    String? productId,
    String? productName,
    int? price,
    int? qty,
    bool? isFreeItem,
    String? instructions,
    String? shopId,
    List<ItemCustomization>? customizations,
  }) {
    return Item(
      lineId: lineId ?? this.lineId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      isFreeItem: isFreeItem ?? this.isFreeItem,
      instructions: instructions ?? this.instructions,
      shopId: shopId ?? this.shopId,
      customizations: customizations ?? this.customizations,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        lineId: json["lineId"],
        productId: json["productId"],
        productName: json["productName"],
        price: json["price"].toInt(),
        qty: json["qty"],
        isFreeItem: json["isFreeItem"],
        instructions: json["instructions"] ?? '',
        shopId: json["shopId"],
        customizations: List<ItemCustomization>.from(
            json["customizations"].map((x) => ItemCustomization.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lineId": lineId,
        "productId": productId,
        "productName": productName,
        "price": price,
        "qty": qty,
        "isFreeItem": isFreeItem,
        "instructions": instructions,
        "shopId": shopId,
        "customizations":
            List<dynamic>.from(customizations.map((x) => x.toJson())),
      };
}

class ItemCustomization {
  final String configId;
  final String groupId;
  final String productId;
  final int price;
  final int qty;

  ItemCustomization({
    required this.configId,
    required this.groupId,
    required this.productId,
    required this.price,
    required this.qty,
  });

  ItemCustomization copyWith({
    String? configId,
    String? groupId,
    String? productId,
    int? price,
    int? qty,
  }) {
    return ItemCustomization(
      configId: configId ?? this.configId,
      groupId: groupId ?? this.groupId,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      qty: qty ?? this.qty,
    );
  }

  factory ItemCustomization.fromJson(Map<String, dynamic> json) =>
      ItemCustomization(
        configId: json["configId"],
        groupId: json["groupId"],
        productId: json["productId"],
        price: json["price"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "configId": configId,
        "groupId": groupId,
        "productId": productId,
        "price": price,
        "qty": qty,
      };
}
