// ignore_for_file: must_be_immutable

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/blocs/blocs_exports.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MainProductListScreen extends StatelessWidget {
  MainProductListScreen({super.key});

  static List list = [];

  bool result = false;

  @override
  Widget build(BuildContext context) {
    context.read<ProductsBloc>().add(ProductFetchInialEvent());
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductsInitialFetchLoadingState) {
          EasyLoading.show();
        }
        // if (state is ProductsInitialFetchSuccesState) {
        //   EasyLoading.dismiss();
        //   list = state.list;
        //   result = false;
        // }

        // if (state is ProductSearchSuccessState) {
        //   EasyLoading.dismiss();
        //   list = state.list;
        //   result = true;
        // }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.kMainBlue,
            body: SafeArea(
                child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // logo and address
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomHeaderWidget(buildContext: context)),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            const Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: SearchBardWidgetButton()),
                            const SizedBox(width: 10),
                            Image.asset(AssestPath.assetCartIconPath)
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // animated text banner
                      result
                          ? Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: CustomTextWidget(
                                  text: 'Results "${list.length}"',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                          : const TextBannerWidget(),

                      const SizedBox(height: 10),

                      // Expanded(
                      //   flex: 0,
                      //   child: ListView.builder(
                      //     itemCount: list.length,
                      //     shrinkWrap: true,
                      //     physics: const ClampingScrollPhysics(),
                      //     itemBuilder: (context, index) {
                      //       return ProductBuilder(model: list[index]);
                      //     },
                      //   ),
                      // ),
                    ]),
              ),
            )),
          ),
        );
      },
    );
  }
}

// class ProductBuilder extends StatelessWidget {
//   // final CategorizedProductModel model;

//   const ProductBuilder({super.key, required this.model});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Hero(
//                   tag: model.category,
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: CustomTextWidget(
//                           text: model.category,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//               const Spacer(),
//               Expanded(
//                 flex: 1,
//                 child: GestureDetector(
//                   onTap: () {
//                     context.read<ProductsBloc>().selectedCategory = model;
//                     Navigator.pushNamed(context, ViewAllProductsScreen.id);
//                   },
//                   child: const CustomTextWidget(
//                       text: "View more..",
//                       fontSize: 15,
//                       color: AppColors.kBlue3,
//                       fontWeight: FontWeight.normal),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           GridView.builder(
//               itemCount: 2,
//               shrinkWrap: true,
//               scrollDirection: FlipEffect.defaultAxis,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 4 / 5.7,
//                   crossAxisSpacing: 20,
//                   mainAxisSpacing: 8.0),
//               itemBuilder: (context, index) => CustomProductCardWidget(
//                     product: model.productList[index],
//                   )),
//           const SizedBox(height: 15),
//         ],
//       ),
//     );
//   }
// }

class TextBannerWidget extends StatelessWidget {
  const TextBannerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 15 / 6,
      child: Stack(
        children: [
          const Positioned(top: 0, left: 0, child: TransperantGrdientBox()),
          const Positioned(bottom: 0, right: 0, child: TransperantGrdientBox()),
          AspectRatio(
            aspectRatio: 15 / 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                        colors: [AppColors.kMainOranage, AppColors.kMainPink])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWidget(
                            text: "CHOOSE",
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                          CustomTextWidget(
                              text: "Your Favourite",
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ]),
                    const SizedBox(width: 5),
                    Expanded(
                      child: DefaultTextStyle(
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 25,
                              fontFamily: "RockfordSans",
                              fontWeight: FontWeight.w900,
                              color: AppColors.kMainBlue),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: AnimatedTextKit(
                                  repeatForever: true,
                                  pause: 1.seconds,
                                  animatedTexts: [
                                    RotateAnimatedText('Appetizers!',
                                        duration: 1.5.seconds,
                                        transitionHeight: 60),
                                    RotateAnimatedText('Liquors!',
                                        duration: 1.5.seconds,
                                        transitionHeight: 60),
                                    RotateAnimatedText('Breakfast Meals!',
                                        duration: 1.5.seconds,
                                        transitionHeight: 60),
                                    RotateAnimatedText('Lunch Meals!',
                                        duration: 1.5.seconds,
                                        transitionHeight: 60),
                                    RotateAnimatedText('Dinner Meals!',
                                        duration: 1.5.seconds,
                                        transitionHeight: 60),
                                  ]),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TransperantGrdientBox extends StatelessWidget {
  const TransperantGrdientBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        AppColors.kMainOranage.withOpacity(0.5),
        AppColors.kMainPink.withOpacity(0.5)
      ])),
    );
  }
}

class SearchBardWidgetButton extends StatefulWidget {
  const SearchBardWidgetButton({super.key});

  @override
  State<SearchBardWidgetButton> createState() => _SearchBardWidgetButtonState();
}

class _SearchBardWidgetButtonState extends State<SearchBardWidgetButton> {
  bool show = false;
  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return show
        ? Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        AppColors.kMainOranage,
                        AppColors.kMainPink
                      ]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            show = !show;
                          });
                        },
                        child: const Icon(Icons.search, color: Colors.white)),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: textEditingController,
                        onChanged: (text) {
                          if (text.isEmpty) {
                            context
                                .read<ProductsBloc>()
                                .add(ProductFetchInialEvent());
                          }
                        },
                        style: CustomTextStyles.textStyleWhite_14.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 15)),
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(width: 10),
              // Flexible(
              //   flex: 0,
              //   child: CustomGradientButton(
              //       onPressed: () => context.read<ProductsBloc>().add(
              //           ProductSearchPressEvent(
              //               query: textEditingController.text)),
              //       width: MediaQuery.sizeOf(context).width / 5,
              //       height: 45,
              //       text: "Go!"),
              // )
            ],
          )
        : SizedBox(
            width: 75,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    show = !show;
                  });
                },
                child: const CustomSearchIconButton()),
          );
  }
}
