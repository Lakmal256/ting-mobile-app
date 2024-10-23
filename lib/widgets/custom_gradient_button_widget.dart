import 'package:app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton(
      {super.key,
      required this.onPressed,
      required this.width,
      required this.height,
      required this.text,
      this.isIcon = false});

  final VoidCallback onPressed;
  final double width;
  final double height;
  final String text;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.kMainOranage, AppColors.kMainPink]),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: CustomTextWidget(text: text, fontSize: 20),
      ),
    );
  }
}
