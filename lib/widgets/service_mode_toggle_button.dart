import 'package:app/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ServiceModeToggleButton extends StatelessWidget {
  const ServiceModeToggleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      cornerRadius: 20.0,
      activeBgColors: const [
        [AppColors.kMainOranage, AppColors.kMainPink],
        [AppColors.kMainOranage, AppColors.kMainPink]
      ],
      activeFgColor: Colors.white,
      inactiveBgColor: AppColors.kBlue1,
      inactiveFgColor: AppColors.kMainGray,
      initialLabelIndex: 0,
      totalSwitches: 2,
      animate: true,
      curve: Curves.elasticOut,
      animationDuration: 800,
      labels: const ['Deliver', 'Pick Up'],
      customTextStyles: [
        CustomTextStyles.textStyleWhiteBold_12.copyWith(fontSize: 12),
        CustomTextStyles.textStyleWhiteBold_12.copyWith(fontSize: 12)
      ],
      radiusStyle: true,
    );
  }
}
