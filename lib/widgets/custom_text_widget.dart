import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final TextDecoration? textDecoration;

  const CustomTextWidget(
      {super.key,
      required this.text,
      required this.fontSize,
      this.color = Colors.white,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.left,
      this.textDecoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontFamily: 'RockfordSans',
            color: color,
            decoration: textDecoration,
            decorationColor: color,
            fontSize: fontSize,
            fontWeight: fontWeight));
  }
}
