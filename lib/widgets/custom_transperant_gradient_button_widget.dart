import 'package:app/themes/app_colors.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomTransperantGradientButton extends StatelessWidget {
  const CustomTransperantGradientButton(
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

  static double opacity = 0.15;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.kMainOranage.withOpacity(opacity),
              AppColors.kMainPink.withOpacity(opacity)
            ]),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child:  ElevatedButton.icon(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            icon:  const Icon(Icons.add),
            label: CustomTextWidget(
              text: text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ))
        );
  }
}
