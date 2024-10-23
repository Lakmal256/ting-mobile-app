import 'package:app/themes/themes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CarouselIndicator extends StatefulWidget {
  const CarouselIndicator(
      {super.key, required this.index, required this.count});

  final int index;
  final int count;

  @override
  State<CarouselIndicator> createState() => _CarouselIndicatorState();
}

class _CarouselIndicatorState extends State<CarouselIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          widget.count,
          (index) => AnimatedSwitcher(
                duration: 2.seconds,
                switchInCurve: Curves.bounceOut,
                child: widget.index == index
                    ? Container(
                        height: 8,
                        width: 20,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              AppColors.kMainOranage,
                              AppColors.kMainPink
                            ]),
                            borderRadius: BorderRadius.circular(3)),
                        margin: const EdgeInsets.only(right: 5))
                    : Container(
                        height: 8,
                        width: 20,
                        decoration: BoxDecoration(
                            color: AppColors.kBlue2,
                            borderRadius: BorderRadius.circular(3)),
                        margin: const EdgeInsets.only(right: 5)),
              )),
    );
  }
}
