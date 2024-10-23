import 'dart:convert';

CartDataModel cartDataModelFromJson(String str) =>
    CartDataModel.fromJson(json.decode(str));

String cartDataModelToJson(CartDataModel data) => json.encode(data.toJson());

class CartDataModel {
  final String customerId;
  final String instructions;
  final List<ItemElement> items;

  CartDataModel({
    required this.customerId,
    required this.instructions,
    required this.items,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) => CartDataModel(
        customerId: json["customerId"],
        instructions: json["instructions"],
        items: List<ItemElement>.from(
            json["items"].map((x) => ItemElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "instructions": instructions,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ItemElement {
  final ItemItem item;
  final String shopId;
  final int quantity;
  final double price;
  final String instructions;
  

  ItemElement({
    required this.item,
    required this.shopId,
    required this.quantity,
    required this.price,
    required this.instructions,
  });

  factory ItemElement.fromJson(Map<String, dynamic> json) => ItemElement(
        item: ItemItem.fromJson(json["item"]),
        shopId: json["shopId"],
        quantity: json["quantity"],
        price: json["price"].toDouble(),
        instructions: json["instructions"],
      );

  Map<String, dynamic> toJson() => {
        "item": item.toJson(),
        "shopId": shopId,
        "quantity": quantity,
        "price": price,
        "instructions": instructions,
      };
}

class ItemItem {
  final String productId;
  final List<ProductConfig> productConfigs;

  ItemItem({
    required this.productId,
    required this.productConfigs,
  });

  factory ItemItem.fromJson(Map<String, dynamic> json) => ItemItem(
        productId: json["productId"],
        productConfigs: List<ProductConfig>.from(
            json["productConfigs"].map((x) => ProductConfig.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productConfigs":
            List<dynamic>.from(productConfigs.map((x) => x.toJson())),
      };
}

class ProductConfig {
  final String configId;
  final int configPrice;
  final int quantity;

  ProductConfig({
    required this.configId,
    required this.configPrice,
    required this.quantity,
  });

  factory ProductConfig.fromJson(Map<String, dynamic> json) => ProductConfig(
        configId: json["configId"],
        configPrice: json["configPrice"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "configId": configId,
        "configPrice": configPrice,
        "quantity": quantity,
      };
}
