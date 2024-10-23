import 'package:app/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextStyles {
  CustomTextStyles._();

  static const TextStyle textStyleWhite_14 =
      TextStyle(fontFamily: 'RockfordSans', fontSize: 14, color: Colors.white);

  static const TextStyle textStyleWhite_12 =
      TextStyle(fontFamily: 'RockfordSans', fontSize: 12, color: Colors.white);

  static const TextStyle textStyleWhite_35 =
      TextStyle(fontFamily: 'RockfordSans', fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold);

  static const TextStyle textStyleWhiteMedium_12 =
      TextStyle(fontFamily: 'RockfordSans', fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500);
  static const TextStyle textStyleWhiteBold_12 =
      TextStyle(fontFamily: 'RockfordSans', fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold);

  static const TextStyle textStyleOrange_12 =
      TextStyle(fontFamily: 'RockfordSans', fontSize: 12, color: AppColors.kMainOranage);

  static const TextStyle textStyleOrangeMedium_12 =
      TextStyle(fontFamily: 'RockfordSans', fontSize: 12, color: AppColors.kMainOranage, fontWeight: FontWeight.w500);
  static const TextStyle textStyleGradientBold_15 =
      TextStyle(fontFamily: 'RockfordSans', fontSize: 15, color: AppColors.kMainOranage, fontWeight: FontWeight.w700);
}
