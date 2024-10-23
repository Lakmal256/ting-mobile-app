import 'dart:convert';

VendorsMenuModel vendorsMenuModelFromJson(String str) {
  try {
    return VendorsMenuModel.fromJson(json.decode(str));
  } catch (e) {
    print("Error decoding JSON: $e");
    rethrow;
  }
}

String vendorsMenuModelToJson(VendorsMenuModel data) =>
    json.encode(data.toJson());

class VendorsMenuModel {
  final List<Menu> menus;

  VendorsMenuModel({
    required this.menus,
  });

  factory VendorsMenuModel.fromJson(Map<String, dynamic> json) {
    return VendorsMenuModel(
      menus: json["menus"] != null
          ? List<Menu>.from(json["menus"].map((x) {
              if (x is Map<String, dynamic>) {
                return Menu.fromJson(x);
              } else {
                print("Error: Expected a map but found: $x");
                return Menu(
                    id: '',
                    name: '',
                    active: '',
                    categories: [],
                    availability: []);
              }
            }))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
      };
}

class Menu {
  final String id;
  final String name;
  final String active;
  final List<MenuCategory> categories;
  final List<Availability> availability;

  Menu({
    required this.id,
    required this.name,
    required this.active,
    required this.categories,
    required this.availability,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        active: json["active"] ?? '',
        categories: json["categories"] != null
            ? List<MenuCategory>.from(json["categories"].map((x) {
                if (x is Map<String, dynamic>) {
                  return MenuCategory.fromJson(x);
                } else {
                  print("Error: Expected a map but found: $x");
                  return MenuCategory(id: '', name: '', products: []);
                }
              }))
            : [],
        availability: json["availability"] != null
            ? List<Availability>.from(json["availability"].map((x) {
                if (x is Map<String, dynamic>) {
                  return Availability.fromJson(x);
                } else {
                  print("Error: Expected a map but found: $x");
                  return Availability(
                      dayOfWeek: '', startTime: '', endTime: '', allDay: false);
                }
              }))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "active": active,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "availability": List<dynamic>.from(availability.map((x) => x.toJson())),
      };
}

class MenuCategory {
  final String id;
  final String name;
  final List<MenuProduct> products;

  MenuCategory({
    required this.id,
    required this.name,
    required this.products,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) => MenuCategory(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        products: json["products"] != null
            ? List<MenuProduct>.from(json["products"].map((x) {
                if (x is Map<String, dynamic>) {
                  return MenuProduct.fromJson(x);
                } else {
                  print("Error: Expected a map but found: $x");
                  return MenuProduct(
                      productId: '',
                      name: '',
                      description: '',
                      photoUrl: '',
                      price: 0.0,
                      ratingPct: null,
                      votes: null);
                }
              }))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Availability {
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool allDay;

  Availability({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.allDay,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        dayOfWeek: json["dayOfWeek"] ?? '',
        startTime: json["startTime"] ?? '',
        endTime: json["endTime"] ?? '',
        allDay: json["allDay"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "dayOfWeek": dayOfWeek,
        "startTime": startTime,
        "endTime": endTime,
        "allDay": allDay,
      };
}

class MenuProduct {
  final String productId;
  final String name;
  final String description;
  final String photoUrl;
  final double price;
  final dynamic ratingPct;
  final dynamic votes;

  MenuProduct({
    required this.productId,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.price,
    required this.ratingPct,
    required this.votes,
  });

  factory MenuProduct.fromJson(Map<String, dynamic> json) => MenuProduct(
        productId: json["productId"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        photoUrl: isValidUrl(json["photoUrl"]) ? json["photoUrl"] : "",
        price: (json["price"] ?? 0.0).toDouble(),
        ratingPct: json["ratingPct"],
        votes: json["votes"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "price": price,
        "ratingPct": ratingPct,
        "votes": votes,
      };
}

bool isValidUrl(String? url) {
  if (url == null) {
    return false;
  }
  Uri? uri = Uri.tryParse(url);
  return uri != null && uri.hasScheme && uri.host.isNotEmpty;
}
