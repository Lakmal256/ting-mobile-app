import 'package:app/themes/themes.dart';
import 'package:flutter/cupertino.dart';

class CustomGradinetTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;

  final Gradient? gradient;

  const CustomGradinetTextWidget(
      {super.key, required this.text, this.style, this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient == null
          ? const LinearGradient(
                  colors: [AppColors.kMainOranage, AppColors.kMainPink])
              .createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height)
            )
          : gradient!.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
      child: Text(text, style: style, textAlign: TextAlign.center, maxLines: 1),
    );
  }
}
