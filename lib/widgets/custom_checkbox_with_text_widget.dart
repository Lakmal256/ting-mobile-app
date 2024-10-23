import 'package:app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../themes/themes.dart';

class CustomCheckboxWithTextWidget extends StatefulWidget {
  final Function(bool?) onHandler;
  final String text;
  final Color textColor;
  const CustomCheckboxWithTextWidget(
      {super.key,
      required this.onHandler,
      required this.text,
      required this.textColor});

  @override
  State<CustomCheckboxWithTextWidget> createState() =>
      _CustomCheckboxWithTextWidgetState();
}

class _CustomCheckboxWithTextWidgetState
    extends State<CustomCheckboxWithTextWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.25,
          child: Checkbox(
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.kMainBlue;
              }
              return AppColors.kBlue1;
            }),
            side:
                WidgetStateBorderSide.resolveWith((states) => const BorderSide(
                      color: AppColors.kBlue3,
                    )),
            checkColor: AppColors.kBlue3,
            value: isChecked,
            onChanged: (val) {
              setState(() {
                isChecked = val!;
              });
              widget.onHandler(val);
            },
          ),
        ),
        CustomTextWidget(
          text: widget.text,
          fontSize: 14,
          color: widget.textColor,
        )
      ],
    );
  }
}
