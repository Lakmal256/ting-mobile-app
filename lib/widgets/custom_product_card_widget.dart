import 'package:app/data/data.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomProductCardWidget extends StatelessWidget {
  const CustomProductCardWidget(
      {super.key, required this.product, required this.onTap});
  final MenuProduct? product;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.kBlue2,
                AppColors.kBlue2.withOpacity(0.3),
              ])),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 5),
            // product image
            AspectRatio(
                aspectRatio: 4 / 3.6,
                child: Hero(
                  tag: product!.productId,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.kBlue2,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                            image:
                                CachedNetworkImageProvider(product!.photoUrl),
                            fit: BoxFit.cover)),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        // sponserd
                        // Container(
                        //   width: 90,
                        //   height: 20,
                        //   decoration: const BoxDecoration(
                        //       color: AppColors.kMainOranage,
                        //       borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(15),
                        //           bottomRight: Radius.circular(15))),
                        //   child: const Center(
                        //       child: CustomTextWidget(
                        //           text: '#1 most liked',
                        //           fontSize: 10,
                        //           fontWeight: FontWeight.bold)),
                        // ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                            child: CustomTextWidget(
                                text: product!.name,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        FittedBox(
                            child: CustomTextWidget(
                                text: "${product!.name} - 5km Away",
                                fontSize: 15,
                                fontWeight: FontWeight.normal))
                      ],
                    )),
                const SizedBox(width: 10),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kGray1, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Row(children: [
                      Image.asset(AssestPath.assetLikeIconPath, width: 15),
                      const SizedBox(width: 2),
                      CustomTextWidget(
                          text: product!.ratingPct ?? "0",
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)
                    ]))
              ],
            ),
            const Spacer(),
            Row(children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CustomTextWidget(
                              textAlign: TextAlign.start,
                              text: product!.price.toString(),
                              fontSize: 18,
                              fontWeight: FontWeight.bold)))),
              const SizedBox(width: 8),
              Flexible(
                  flex: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: onTap,
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.kBlue3,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 7),
                        child: const FittedBox(
                            child: CustomTextWidget(
                                text: 'Add',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ))
            ]),
            const SizedBox(height: 3)
          ],
        ),
      ),
    );
  }
}
