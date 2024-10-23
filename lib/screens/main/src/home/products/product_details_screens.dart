import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../../../../themes/themes.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  static const id = "product_details_screen";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.kMainBlue,
          // appBar: AppBar(
          //   centerTitle: true,
          //   backgroundColor: Colors.transparent,
          //   title: Padding(
          //     padding: const EdgeInsets.only(top: 20),
          //     child: ,
          //   ),
          // ),
          body: SafeArea(
              child: SingleChildScrollView(
                  child: SizedBox(
            // ,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(Icons.navigate_before,
                            color: Colors.white, size: 45),
                        Image.asset(AssestPath.assestLogoPath,
                            width: 80.0, fit: BoxFit.cover)
                      ]),
                      const Row(
                        children: [
                          CustomTextWidget(text: 'Nara Thai', fontSize: 14),
                          SizedBox(width: 10),
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          )
                        ],
                      )
                    ]),
                const SizedBox(height: 25),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // detailed image
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      // item title

                      const SizedBox(height: 20),
                      const CustomTextWidget(
                          text: "Tom Yum Soup",
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      const CustomTextWidget(
                        text:
                            'The name “tom yum” is composed of two Thai words. Tom refers to the boiling process, while yam means “mixed”.',
                        fontSize: 14,
                        color: AppColors.kGray2,
                      ),

                      const SizedBox(height: 10),
                      const CustomTextWidget(
                          text: "Main Ingredients",
                          fontSize: 16,
                          color: AppColors.kGray1,
                          fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      const Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextWidget(
                              text:
                                  'The name “tom yum” is composed of two Thai words. Tom refers to the boiling process, while yam means “mixed”.',
                              fontSize: 12,
                              color: AppColors.kGray1,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: RatingCardWidget(ratingValue: 4.5),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // item price
                          CustomTextWidget(
                            text: 'Rs. 3,200',
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          // buy now button widget
                          BuyNowButtonWidget()
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ))),
        ));
  }
}

class BuyNowButtonWidget extends StatelessWidget {
  const BuyNowButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.kMainOranage, AppColors.kMainPink]),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: const Center(
            child: CustomTextWidget(
          text: 'Buy Now',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )),
      ),
    );
  }
}

class RatingCardWidget extends StatelessWidget {
  final double ratingValue;
  const RatingCardWidget({super.key, required this.ratingValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.kGray1, width: 1)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 2),
            CustomTextWidget(text: '$ratingValue', fontSize: 14)
          ]),
    );
  }
}

// class CutomeAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CutomeAppBar({
//     super.key,
//   });

//   @override
//   Size get preferredSize => const Size.fromHeight(
//       kToolbarHeight); // Specify the preferred size of the app bar

//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
