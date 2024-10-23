import 'package:app/data/data.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class CustomProductInfoCardWidget extends StatelessWidget {
  const CustomProductInfoCardWidget(
      {super.key, required this.productItem, this.showVendor = true});
  final ProductItem? productItem;
  final bool showVendor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
            aspectRatio: showVendor ? 16 / 7 : 16 / 6,
            child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // left column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                                fit: BoxFit.fill,
                                child: CustomTextWidget(
                                    text: productItem!.displayName,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            CustomTextWidget(
                                text: ValidationService()
                                    .formatPrice(productItem!.price.toDouble()),
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                            showVendor
                                ? const Spacer()
                                : const SizedBox.shrink(),
                            showVendor
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 15),
                                      const SizedBox(
                                          width: 35,
                                          child: CustomNetworkImage(
                                              imageUrl:
                                                  "https://i.postimg.cc/R0wXdCYz/1088px-Pizza-Hut-logo.png")),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              child: CustomGradinetTextWidget(
                                                  text:
                                                      'From ${productItem!.skuName}',
                                                  style: CustomTextStyles
                                                      .textStyleWhite_14),
                                            ),
                                            const CustomGradinetTextWidget(
                                                text: 'Nawala'),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            showVendor
                                ? const Spacer()
                                : const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.timelapse_sharp,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(width: 4),
                                CustomTextWidget(
                                  text:
                                      '${productItem!.prepareTime} min * 2 km',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(width: 20),
                                Image.asset(AssestPath.assetLikeIconPath,
                                    width: 20),
                                const SizedBox(width: 5),
                                // votes
                                const CustomTextWidget(
                                    text: '256',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)
                              ],
                            ),
                          ],
                        ),
                      ),

                      Stack(children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: AspectRatio(
                                aspectRatio: 1.1,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    // product image
                                    child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAyfOnUpz7Y5Azb7qLh_UICqmvRRlaKfy_Ow&usqp=CAU')))),
                        Positioned(
                            bottom: 3,
                            right: 20,
                            left: 20,
                            child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      AppColors.kMainOranage,
                                      AppColors.kMainPink
                                    ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                height: 30,
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 3),
                                      CustomTextWidget(
                                          text: 'Add',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)
                                    ])))
                      ])
                    ]))),
        const SizedBox(height: 5),
        const DottedLine(dashColor: Colors.white),
        const SizedBox(height: 5),
      ],
    );
  }
}
