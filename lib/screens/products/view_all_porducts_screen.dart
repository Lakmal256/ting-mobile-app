import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ViewAllProductsScreen extends StatelessWidget {
  const ViewAllProductsScreen({super.key});

  static const String id = 'view_all_products';

  @override
  Widget build(BuildContext context) {
    // var selected = context.read<ProductsBloc>().selectedCategory;
    return Scaffold(
      backgroundColor: AppColors.kMainBlue,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // header
                const HeaderWithBackButtonWidget(),
                //
                // Hero(
                //   tag: selected.category,
                //   child: FittedBox(
                //     fit: BoxFit.scaleDown,
                //     child: CustomTextWidget(
                //         text: selected.category,
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold),
                //   ),
                // ),
                const SizedBox(height: 10),
                // Expanded(
                //   child: GridView.builder(
                //       itemCount: selected.productList.length,
                //       shrinkWrap: true,
                //       padding: EdgeInsets.zero,
                //       scrollDirection: Axis.vertical,
                //       physics: const PageScrollPhysics(),
                //       gridDelegate:
                //           const SliverGridDelegateWithFixedCrossAxisCount(
                //               crossAxisCount: 2,
                //               childAspectRatio: 4 / 5.7,
                //               crossAxisSpacing: 20.0,
                //               mainAxisSpacing: 20.0),
                //       itemBuilder: (context, index) {
                //         return CustomProductCardWidget(
                //           product: selected.productList[index],
                //         );
                //       }),
                // ),
                const SizedBox(height: 15),
              ]),
        ),
      ),
    );
  }
}
