import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../themes/themes.dart';

class CustomSearchCardWidget extends StatelessWidget {
  const CustomSearchCardWidget({super.key, required this.onTap, required this.text, required this.iconUrl});

  final VoidCallback onTap;
  final String text;
  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.kBlue2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.scaleDown,
                    width: 10,
                    imageUrl: iconUrl,
                  ),
                ),
              ),
              FittedBox(
                child: CustomTextWidget(text: text, fontSize: 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}
