// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/screens/screens.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';

class ViewProductsScreen extends StatelessWidget {
  const ViewProductsScreen({super.key});
  static const String id = 'view_product';

  @override
  Widget build(BuildContext context) {
    // Product product = context.read<ProductsBloc>().selectedProduct;
    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const MainProductImage(),
            // Positioned(
            //   top: MediaQuery.of(context).size.height * 0.45,
            //   left: 0,
            //   right: 0,
            //   // product information container
            //   child: ProductDataContainer(product: product),
            // ),
            // back button
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 15,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductDataContainer extends StatelessWidget {
  var product;

  ProductDataContainer({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: AppColors.kMainBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Name
                  Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CustomTextWidget(
                                text: "product.displayName",
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )),
                  Spacer(flex: 1),
                  QuantitySelectorWidget()
                ]),
            const SizedBox(height: 15),
            // Product Description
            const CustomTextWidget(
                textAlign: TextAlign.justify,
                text:
                    'Fried chicken is a delicious dish made by coating chicken in seasoned flour and frying until golden and crispy.',
                fontSize: 15),
            const SizedBox(height: 20),

            // ingredients and vots
            const Expanded(
              flex: 0,
              child: IngredientsVots(),
            ),
            const SizedBox(height: 20),

            // price
            Align(
              alignment: Alignment.centerLeft,
              child: CustomTextWidget(
                text: ValidationService().formatPrice(0),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: const GradientBoxBorder(
                            gradient: LinearGradient(colors: [
                          AppColors.kMainOranage,
                          AppColors.kMainPink
                        ]))),
                    child: const Center(
                      child:
                          CustomTextWidget(text: 'Add to Cart', fontSize: 20),
                    )),
                CustomGradientButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, OrderStatusScreen.id),
                    width: 150,
                    height: 50,
                    text: 'Buy Now')
              ],
            )
          ],
        ),
      ),
    );
  }
}

class IngredientsVots extends StatelessWidget {
  const IngredientsVots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                text: 'Main Ingredients',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.kGray1,
              ),

              // ingredients
              CustomTextWidget(
                text:
                    'Chicken pieces, flour, buttermilk or eggs, and spices like salt, pepper, and paprika.',
                textAlign: TextAlign.start,
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: AppColors.kGray1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 25),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.kGray1, width: 1),
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(children: [
            Image.asset(AssestPath.assetLikeIconPath, width: 20),
            const SizedBox(width: 5),
            // rating
            const CustomTextWidget(
                text: '45',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ]),
        )
      ],
    );
  }
}

class QuantitySelectorWidget extends StatelessWidget {
  const QuantitySelectorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<ProductsBloc>().quantity = 1;
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (previous, current) {
        if (current is ProductQuntityState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 35),
                elevation: 0,
              ),
              onPressed: () => context
                  .read<ProductsBloc>()
                  .add(const ProductQuentityButtonEvent(value: Quantity.minus)),
              child: const CustomTextWidget(
                text: '-',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 14,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomTextWidget(
                  text: context
                      .read<ProductsBloc>()
                      .quantity
                      .toString()
                      .padLeft(2, '0'),
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 35),
                  elevation: 0),
              onPressed: () => context
                  .read<ProductsBloc>()
                  .add(const ProductQuentityButtonEvent(value: Quantity.plus)),
              child: const CustomTextWidget(
                text: '+',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ]),
        );
      },
    );
  }
}

class MainProductImage extends StatelessWidget {
  const MainProductImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Hero(
            tag: 'product1',
            child: CachedNetworkImage(
              imageUrl:
                  'https://www.namesnack.com/images/namesnack-fast-food-restaurant-business-names-4240x2832-20200915.jpeg?crop=4:3,smart&width=1200&dpr=2',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
