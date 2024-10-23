import 'dart:async';

import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/assest_path.dart';
import 'custom_text_widget.dart';

class CustomToastMessangerToast extends StatefulWidget {
  final String message;
  final int durationSeconds;

  const CustomToastMessangerToast(
      {super.key, required this.message, this.durationSeconds = 2});

  @override
  State<CustomToastMessangerToast> createState() =>
      _CustomToastMessangerToastState();
}

class _CustomToastMessangerToastState extends State<CustomToastMessangerToast> {
  late Timer _timer;

  @override
  void initState() {
    // Start a timer to close the toast after the specified duration
    _timer = Timer(Duration(seconds: widget.durationSeconds), onClose);
    super.initState();
  }

  @override
  void dispose() {
    // Ensure the timer is canceled when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void onClose() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          gradient: LinearGradient(
              colors: [AppColors.kMainOranage, AppColors.kMainPink])),
      child: Column(children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: 122,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(15))),
            child: Center(
                child: Image.asset(
              AssestPath.assestDownIconPath,
              width: 40.0,
            )),
          ),
        ),
        const SizedBox(height: 35),
        CustomTextWidget(
          text: widget.message,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
