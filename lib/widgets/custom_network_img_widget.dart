import 'package:app/themes/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        placeholder: (context, str) => const Placeholder(),
        errorWidget: (context, str, ob) => const Placeholder(),
        imageUrl: imageUrl);
  }
}

class Placeholder extends StatelessWidget {
  const Placeholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kGray1.withOpacity(0.5),
      child: Image.asset(
        AssestPath.assestImgPlaceholder,
        fit: BoxFit.cover,
      ),
    );
  }
}
