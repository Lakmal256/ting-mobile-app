import 'package:app/widgets/carousel_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/models/marketplace/banners_model.dart';
import '../themes/app_colors.dart';

class CustomOffersSliderWidget extends StatefulWidget {
  final List<BannersModel> bannersList;
  const CustomOffersSliderWidget({super.key, required this.bannersList});

  @override
  State<CustomOffersSliderWidget> createState() =>
      _CustomOffersSliderWidgetState();
}

class _CustomOffersSliderWidgetState extends State<CustomOffersSliderWidget> {
  CarouselController controller = CarouselController();

  int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          items: widget.bannersList
              .map((item) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: PromoBanner(
                      banner: item,
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            autoPlayCurve: Curves.elasticOut,
            autoPlayAnimationDuration: 1800.milliseconds,
            viewportFraction: 1,
            aspectRatio: 18 / 9,
            autoPlay: true,
            padEnds: false,
            onPageChanged: (index, reason) => setState(() {
              _currentIndex = index;
            }),
          ),
        ),
        const SizedBox(height: 10),
        CarouselIndicator(
            index: _currentIndex, count: widget.bannersList.length)
      ],
    );
  }
}

class GlobalPromoBanner extends StatelessWidget {
  const GlobalPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.kMainOranage, AppColors.kMainPink],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Transform.scale(
              scale: 1.25,
              child: Image.asset(
                'assets/kfc_logo.png',
                fit: BoxFit.cover,
                width: double.infinity,
                opacity: const AlwaysStoppedAnimation(.4),
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GET\nFREE DELIVERY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.1),
                  ),
                  Text(
                    'On your first order with KFC!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final BannersModel banner;
  const PromoBanner({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.kMainOranage, AppColors.kMainPink],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: media.width * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        banner.promotion?.promotionName ?? '',
                        maxLines: 3,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: media.width * 0.6,
                    child: Text(
                      banner.bannerDescription,
                      maxLines: 3,
                      style: const TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: SizedBox(
                width: media.width * 0.2,
                child: CachedNetworkImage(
                  imageUrl: banner.bannerImageUrl,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
