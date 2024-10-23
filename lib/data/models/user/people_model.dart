import 'dart:convert';

PeopleModel peopleModelFromJson(String str) =>
    PeopleModel.fromJson(json.decode(str));

String peopleModelToJson(PeopleModel data) => json.encode(data.toJson());

class PeopleModel {
  String resourceName;
  String etag;
  List<Name> names;

  PeopleModel({
    required this.resourceName,
    required this.etag,
    required this.names,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) => PeopleModel(
        resourceName: json["resourceName"],
        etag: json["etag"],
        names: List<Name>.from(json["names"].map((x) => Name.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resourceName": resourceName,
        "etag": etag,
        "names": List<dynamic>.from(names.map((x) => x.toJson())),
      };
}

class Name {
  Metadata metadata;
  String displayName;
  String familyName;
  String givenName;
  String displayNameLastFirst;
  String unstructuredName;

  Name({
    required this.metadata,
    required this.displayName,
    required this.familyName,
    required this.givenName,
    required this.displayNameLastFirst,
    required this.unstructuredName,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        metadata: Metadata.fromJson(json["metadata"]),
        displayName: json["displayName"],
        familyName: json["familyName"],
        givenName: json["givenName"],
        displayNameLastFirst: json["displayNameLastFirst"],
        unstructuredName: json["unstructuredName"],
      );

  Map<String, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "displayName": displayName,
        "familyName": familyName,
        "givenName": givenName,
        "displayNameLastFirst": displayNameLastFirst,
        "unstructuredName": unstructuredName,
      };
}

class Metadata {
  bool primary;
  Source source;
  bool sourcePrimary;

  Metadata({
    required this.primary,
    required this.source,
    required this.sourcePrimary,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        primary: json["primary"],
        source: Source.fromJson(json["source"]),
        sourcePrimary: json["sourcePrimary"],
      );

  Map<String, dynamic> toJson() => {
        "primary": primary,
        "source": source.toJson(),
        "sourcePrimary": sourcePrimary,
      };
}

class Source {
  String type;
  String id;

  Source({
    required this.type,
    required this.id,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        type: json["type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
      };
}
