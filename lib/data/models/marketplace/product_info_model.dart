import 'dart:convert';

ProductInfoModel productInfoModelFromJson(String str) => ProductInfoModel.fromJson(json.decode(str));

String productInfoModelToJson(ProductInfoModel data) => json.encode(data.toJson());

class ProductInfoModel {
    final String productId;
    final String name;
    final String shopId;
    final String shopName;
    final String description;
    final String photoUrl;
    final int price;
    final String currency;
    final dynamic ratingPct;
    final dynamic rating;
    final dynamic votes;
    final int calories;
    final int kilojoules;
    final bool isAlcoholic;
    final bool isFeatured;
    final bool isGluten;
    final bool isVegan;
    final bool isVegetarian;
    final String temperature;
    final String purchaseMode;
    final String weightUnit;
    final int avgWeight;
    final int minWeight;
    final int startWeight;
    final int maxWeight;
    final int weightIncrement;
    final List<Customization> customizations;

    ProductInfoModel({
        required this.productId,
        required this.name,
        required this.shopId,
        required this.shopName,
        required this.description,
        required this.photoUrl,
        required this.price,
        required this.currency,
        required this.ratingPct,
        required this.rating,
        required this.votes,
        required this.calories,
        required this.kilojoules,
        required this.isAlcoholic,
        required this.isFeatured,
        required this.isGluten,
        required this.isVegan,
        required this.isVegetarian,
        required this.temperature,
        required this.purchaseMode,
        required this.weightUnit,
        required this.avgWeight,
        required this.minWeight,
        required this.startWeight,
        required this.maxWeight,
        required this.weightIncrement,
        required this.customizations,
    });

    factory ProductInfoModel.fromJson(Map<String, dynamic> json) => ProductInfoModel(
        productId: json["productId"],
        name: json["name"],
        shopId: json["shopId"],
        shopName: json["shopName"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        price: json["price"],
        currency: json["currency"],
        ratingPct: json["ratingPct"],
        rating: json["rating"],
        votes: json["votes"],
        calories: json["calories"],
        kilojoules: json["kilojoules"],
        isAlcoholic: json["isAlcoholic"],
        isFeatured: json["isFeatured"],
        isGluten: json["isGluten"],
        isVegan: json["isVegan"],
        isVegetarian: json["isVegetarian"],
        temperature: json["temperature"],
        purchaseMode: json["purchaseMode"],
        weightUnit: json["weightUnit"],
        avgWeight: json["avgWeight"],
        minWeight: json["minWeight"],
        startWeight: json["startWeight"],
        maxWeight: json["maxWeight"],
        weightIncrement: json["weightIncrement"],
        customizations: List<Customization>.from(json["customizations"].map((x) => Customization.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "shopId": shopId,
        "shopName": shopName,
        "description": description,
        "photoUrl": photoUrl,
        "price": price,
        "currency": currency,
        "ratingPct": ratingPct,
        "rating": rating,
        "votes": votes,
        "calories": calories,
        "kilojoules": kilojoules,
        "isAlcoholic": isAlcoholic,
        "isFeatured": isFeatured,
        "isGluten": isGluten,
        "isVegan": isVegan,
        "isVegetarian": isVegetarian,
        "temperature": temperature,
        "purchaseMode": purchaseMode,
        "weightUnit": weightUnit,
        "avgWeight": avgWeight,
        "minWeight": minWeight,
        "startWeight": startWeight,
        "maxWeight": maxWeight,
        "weightIncrement": weightIncrement,
        "customizations": List<dynamic>.from(customizations.map((x) => x.toJson())),
    };
}

class Customization {
    final int groupOrder;
    final String groupId;
    final String groupName;
    final int maxSelectItems;
    final int minSelectItems;
    final bool multiSelect;
    final List<GroupDetail> groupDetails;

    Customization({
        required this.groupOrder,
        required this.groupId,
        required this.groupName,
        required this.maxSelectItems,
        required this.minSelectItems,
        required this.multiSelect,
        required this.groupDetails,
    });

    factory Customization.fromJson(Map<String, dynamic> json) => Customization(
        groupOrder: json["groupOrder"],
        groupId: json["groupId"],
        groupName: json["groupName"],
        maxSelectItems: json["maxSelectItems"],
        minSelectItems: json["minSelectItems"],
        multiSelect: json["multiSelect"],
        groupDetails: List<GroupDetail>.from(json["groupDetails"].map((x) => GroupDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "groupOrder": groupOrder,
        "groupId": groupId,
        "groupName": groupName,
        "maxSelectItems": maxSelectItems,
        "minSelectItems": minSelectItems,
        "multiSelect": multiSelect,
        "groupDetails": List<dynamic>.from(groupDetails.map((x) => x.toJson())),
    };
}

class GroupDetail {
    final String id;
    final String productId;
    final String productName;
    final int price;
    final int maxQuanty;
    final bool multiQuanty;

    GroupDetail({
        required this.id,
        required this.productId,
        required this.productName,
        required this.price,
        required this.maxQuanty,
        required this.multiQuanty,
    });

    factory GroupDetail.fromJson(Map<String, dynamic> json) => GroupDetail(
        id: json["id"],
        productId: json["productId"],
        productName: json["productName"],
        price: json["price"],
        maxQuanty: json["maxQuanty"],
        multiQuanty: json["multiQuanty"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "productName": productName,
        "price": price,
        "maxQuanty": maxQuanty,
        "multiQuanty": multiQuanty,
    };
}
