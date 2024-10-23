// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum FilterType {
  promotions,
  deliveryFee,
  deliveryTime,
  distance,
  openingHours,
  topMerchant,
  rating,
  price,
  dietary,
  sort,
}

class FilterDataModel {
  final FilterType filterType;
  final String value;

  FilterDataModel({required this.filterType, required this.value});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filterType': filterType,
      'value': value,
    };
  }

  factory FilterDataModel.fromMap(Map<String, dynamic> map) {
    return FilterDataModel(
      filterType: map['filterType'] as FilterType,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterDataModel.fromJson(String source) =>
      FilterDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
