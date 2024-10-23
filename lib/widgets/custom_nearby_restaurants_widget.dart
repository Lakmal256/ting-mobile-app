import 'dart:ffi';

import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum RestaurantType { featured, mostLiked, none }

class CustomNearbyResturantsWidget extends StatefulWidget {
  const CustomNearbyResturantsWidget({
    super.key,
    required this.restaurantType,
    required this.index,
    required this.bannerImage,
    required this.shopName,
    required this.distance,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  final RestaurantType restaurantType;
  final int index;
  final String? bannerImage;
  final String? shopName;
  final String? distance;
  final Float? rating;
  final dynamic deliveryTime;
  final String? deliveryFee;

  @override
  State<CustomNearbyResturantsWidget> createState() =>
      _CustomNearbyResturantsWidgetState();
}

class _CustomNearbyResturantsWidgetState
    extends State<CustomNearbyResturantsWidget> {
  // List<String> imgList = [
  //   "https://media.post.rvohealth.io/wp-content/uploads/2020/09/healthy-eating-ingredients-732x549-thumbnail.jpg",
  //   "https://media.istockphoto.com/id/1316145932/photo/table-top-view-of-spicy-food.jpg?s=612x612&w=0&k=20&c=eaKRSIAoRGHMibSfahMyQS6iFADyVy1pnPdy1O5rZ98=",
  //   "https://s7d1.scene7.com/is/image/mcdonalds/2_Pub_Commitment_574x384:2-column-desktop?resmode=sharp2"
  // ];

  // int currentIndex = 0;
  // Timer? timer;
  // late AnimationController controller;
  // int delay = Random().nextInt(4) + 1;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = AnimationController(vsync: this);
  //   Timer(Duration(seconds: delay), () {
  //     timer = Timer.periodic(const Duration(seconds: 4), (Timer t) {
  //       setState(() {
  //         currentIndex = (currentIndex + 1) % imgList.length;
  //         // controller.repeat();
  //       });
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   timer?.cancel(); // Cancel the timer
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: AspectRatio(
          aspectRatio: 16 / 11,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: [
                // image
                AspectRatio(
                  aspectRatio: 15 / 8,
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(widget
                                              .bannerImage !=
                                          null &&
                                      widget.bannerImage!.isNotEmpty
                                  ? widget.bannerImage ?? ''
                                  : 'https://media.post.rvohealth.io/wp-content/uploads/2020/09/healthy-eating-ingredients-732x549-thumbnail.jpg')),
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15))),
                ),

                // sponserd
                if (widget.restaurantType != RestaurantType.none)
                  Container(
                    width: 140,
                    height: 35,
                    decoration: BoxDecoration(
                        color: widget.restaurantType == RestaurantType.featured
                            ? AppColors.kMainPink
                            : AppColors.kMainOranage,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Center(
                        child: CustomTextWidget(
                            text:
                                widget.restaurantType == RestaurantType.featured
                                    ? '#Sponserd'
                                    : "#${widget.index + 1} most liked",
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomTextWidget(
                              text: widget.shopName ?? 'Coffee 4U - Borella',
                              fontSize: 15),
                          const SizedBox(width: 10),
                          const Icon(Icons.stars_rounded,
                              color: Colors.white, size: 16)
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 5),
                          CustomTextWidget(
                              text:
                                  '${widget.deliveryTime ?? '15 - 20'} mins  *Rs.${widget.deliveryFee ?? '200.00'}',
                              color: AppColors.kGray2,
                              fontSize: 14),
                          const SizedBox(width: 10),
                          CustomTextWidget(
                              text: widget.distance?.toLowerCase() ?? '',
                              fontSize: 15),
                          const SizedBox(width: 10),
                          const Icon(Icons.star,
                              color: Colors.orange, size: 16),
                          const SizedBox(width: 5),
                          CustomTextWidget(
                              text: widget.rating?.toString() ?? '4.7',
                              fontSize: 15),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
