import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBannerWidget extends StatelessWidget {
  const CustomBannerWidget({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 3.5,
      child: Stack(
        children: [
          SvgPicture.asset("assets/backgrounds/sub_background.svg",
              fit: BoxFit.fill, width: double.infinity),
          Positioned(
              left: 25,
              bottom: 0,
              top: 0,
              right: 25,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomTextWidget(
                            text: "CHOOSE",
                            fontSize: 35,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: CustomTextWidget(
                                  text: "Your Favorite",
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: CustomTextWidget(
                                  text: type,
                                  fontSize: 25,
                                  color: AppColors.kMainBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ])),
        ],
      ),
    );
  }
}
