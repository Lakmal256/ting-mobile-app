import 'dart:convert';

CheckoutModel checkoutModelFromJson(String str) =>
    CheckoutModel.fromJson(json.decode(str));

String checkoutModelToJson(CheckoutModel data) => json.encode(data.toJson());

class CheckoutModel {
  final List<Cart> cart;
  final String currency;
  final double shippingCost;

  CheckoutModel({
    required this.cart,
    required this.currency,
    required this.shippingCost,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
        cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
        currency: json["currency"],
        shippingCost: json["shippingCost"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
        "currency": currency,
        "shippingCost": shippingCost,
      };
}

class Cart {
  final String shopId;
  final String shopName;
  final double shopLongitude;
  final double shopLatitude;
  final String customerId;
  final List<CheckoutCartItem> items;
  final double shopTotal;
  final List<DiscountListElement> discountList;
  final List<DiscountListElement> taxList;

  Cart({
    required this.shopId,
    required this.shopName,
    required this.shopLongitude,
    required this.shopLatitude,
    required this.customerId,
    required this.items,
    required this.shopTotal,
    required this.discountList,
    required this.taxList,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        shopId: json["shopId"],
        shopName: json["shopName"],
        shopLongitude: json["shopLongitude"]?.toDouble(),
        shopLatitude: json["shopLatitude"]?.toDouble(),
        customerId: json["customerId"],
        items: List<CheckoutCartItem>.from(
          json["items"]?.map((x) => CheckoutCartItem.fromJson(x)) ?? []),
      shopTotal: json["shopTotal"]?.toDouble() ?? 0.0,
      discountList: json["discountList"] != null
          ? List<DiscountListElement>.from(
              json["discountList"].map((x) => DiscountListElement.fromJson(x)))
          : [],
      taxList: json["taxList"] != null
          ? List<DiscountListElement>.from(
              json["taxList"].map((x) => DiscountListElement.fromJson(x)))
          : [],
      );

  Map<String, dynamic> toJson() => {
        "shopId": shopId,
        "shopName": shopName,
        "shopLongitude": shopLongitude,
        "shopLatitude": shopLatitude,
        "customerId": customerId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "shopTotal": shopTotal,
        "discountList": List<dynamic>.from(discountList.map((x) => x.toJson())),
        "taxList": List<dynamic>.from(taxList.map((x) => x.toJson())),
      };
}

class DiscountListElement {
  final String name;
  final double amount;

  DiscountListElement({
    required this.name,
    required this.amount,
  });

  factory DiscountListElement.fromJson(Map<String, dynamic> json) =>
      DiscountListElement(
        name: json["name"],
        amount: json["amount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
      };
}

class CheckoutCartItem {
  final String lineId;
  final String productId;
  final String productName;
  final int price;
  final int discountedPrice;
  final int qty;
  final String currency;
  final bool isFreeItem;
  final String shopId;
  final String shopName;
  final double shopLongitude;
  final double shopLatitude;
  final dynamic customizations;
  final int lineTotal;

  CheckoutCartItem({
    required this.lineId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.discountedPrice,
    required this.qty,
    required this.currency,
    required this.isFreeItem,
    required this.shopId,
    required this.shopName,
    required this.shopLongitude,
    required this.shopLatitude,
    required this.customizations,
    required this.lineTotal,
  });

  factory CheckoutCartItem.fromJson(Map<String, dynamic> json) =>
      CheckoutCartItem(
        lineId: json["lineId"],
        productId: json["productId"],
        productName: json["productName"],
        price: json["price"],
        discountedPrice: json["discountedPrice"],
        qty: json["qty"],
        currency: json["currency"],
        isFreeItem: json["isFreeItem"],
        shopId: json["shopId"],
        shopName: json["shopName"],
        shopLongitude: json["shopLongitude"]?.toDouble(),
        shopLatitude: json["shopLatitude"]?.toDouble(),
        customizations: json["customizations"],
        lineTotal: json["lineTotal"],
      );

  Map<String, dynamic> toJson() => {
        "lineId": lineId,
        "productId": productId,
        "productName": productName,
        "price": price,
        "discountedPrice": discountedPrice,
        "qty": qty,
        "currency": currency,
        "isFreeItem": isFreeItem,
        "shopId": shopId,
        "shopName": shopName,
        "shopLongitude": shopLongitude,
        "shopLatitude": shopLatitude,
        "customizations": customizations,
        "lineTotal": lineTotal,
      };
}
