import 'dart:convert';

import 'package:app/data/models/marketplace/product_info_model.dart';

class CustomizationModel {
  final String groupId;
  final GroupDetail groupDetails;
  final int quantity;

  CustomizationModel({
    required this.groupId,
    required this.groupDetails,
    required this.quantity,
  });

  CustomizationModel copyWith(
      {String? groupId, GroupDetail? groupDetails, int? quantity}) {
    return CustomizationModel(
      groupId: groupId ?? this.groupId,
      groupDetails: groupDetails ?? this.groupDetails,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId,
      'groupDetails': groupDetails.toJson(),
      'quantity': quantity
    };
  }

  factory CustomizationModel.fromMap(Map<String, dynamic> map) {
    return CustomizationModel(
      groupId: map['groupId'] as String,
      groupDetails:
          GroupDetail.fromJson(map['groupDetails'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomizationModel.fromJson(String source) =>
      CustomizationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
