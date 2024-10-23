import 'dart:convert';

List<ShopTypeModel> shopTypeFromJson(String str) => List<ShopTypeModel>.from(
    json.decode(str).map((x) => ShopTypeModel.fromJson(x)));

String shopTypeDtoToJson(List<ShopTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShopTypeModel {
  final String id;
  final String name;
  final String icon;

  ShopTypeModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory ShopTypeModel.fromJson(Map<String, dynamic> json) => ShopTypeModel(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}
