import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:flutter/material.dart';

import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../blocs/blocs_exports.dart';
import '../../../../cubits/cubits.dart';
import '../../../../data/models/marketplace/banners_model.dart';

class DepartmentScreen extends StatefulWidget {
  final List<BannersModel> bannersList;
  const DepartmentScreen({super.key, required this.bannersList});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  late List<CategoriesModel> categoriesList;
  PageController pageController = PageController();
  bool isLoading = true;

  @override
  void initState() {
    fetchHomeData();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    fetchHomeData();
  }

  void fetchHomeData() async {
    var location = context.read<CurrentLocationCubit>();
    await location.getLocation(context: context);
    if (!mounted) return;
    context.read<HomeBloc>().add(HomeFetchDataEvent(
        address: location.selectedAddress, department: "Restaurants"));
    context.read<CartBloc>().add(CartFetchDataEvent(
        customerId: context.read<ProfileBloc>().userModel.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
      if (state is HomeLoadingState) {
        isLoading = true;
      }

      if (state is HomeDateErrorState) {
        isLoading = true;
        context
            .read<ToastBloc>()
            .add(MakeToastEvent(message: state.errorMessage, context: context));
      }

      if (state is HomeDataFetchSuccess) {
        isLoading = false;
        categoriesList = state.categoriesList;
      }

      if (state is HomeDataFilterdState) {}

      if (state is HomeDataFilterCleanState) {}
    }, builder: (context, state) {
      return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.kMainBlue,
            body: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  child: isLoading
                      ? SizedBox(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height,
                          child:
                              const Center(child: CircularProgressIndicator()))
                      : SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.06),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                child:
                                    CustomHeaderWidget(buildContext: context),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () => context.pop(),
                                            padding: EdgeInsets.zero,
                                            style: const ButtonStyle(
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap),
                                            icon: const Icon(
                                                Icons.navigate_before_rounded,
                                                color: Colors.white,
                                                size: 35)),
                                        const CustomTextWidget(
                                            text: "Restaurants",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            textAlign: TextAlign.left),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // search bar
                              const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 15),
                                  child: CustomSearchTextWidget(
                                    tappable: false,
                                    searchView: null,
                                    currentSearchTerm: '',
                                  )),

                              const SizedBox(height: 20.0),

                              // banner
                              const CustomBannerWidget(
                                type: "Restaurants",
                              ),

                              const SizedBox(height: 20),

                              // Categories
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomTextWidget(
                                        text: "Categories",
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: CustomCategoriesScrollWidget(
                                    categoryList: categoriesList,
                                    onSelect: (name) {
                                      log("Selected : $name");
                                    },
                                  )),
                              const SizedBox(height: 25),

                              // filteration
                              Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: CustomFilterWidget(
                                    selectedFilterOptionsList:
                                        (selectedFilterOptionsList) {},
                                  )),

                              const SizedBox(height: 30),
                              // Packaging & Offers
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomTextWidget(
                                        text: "Packages & Offers",
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 10),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: CustomOffersSliderWidget(
                                  bannersList: widget.bannersList,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // near by resturnets for user
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomTextWidget(
                                        text: "Resturants Near You",
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                              ),

                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: 5,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        CustomNearbyResturantsWidget(
                                          index: index,
                                          restaurantType:
                                              RestaurantType.featured,
                                          shopName: '',
                                          bannerImage: '',
                                          deliveryTime: null,
                                          distance: null,
                                          rating: null,
                                          deliveryFee: null,
                                        )),
                              ),
                            ],
                          ),
                        ),
                )),
          ));
    });
  }
}

// class AnimatedTextBannerWidget extends StatelessWidget {
//   const AnimatedTextBannerWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         // const ,
//         const SizedBox(width: 5),
//         Expanded(
//           child: ,
//         )
//       ],
//     );
//   }
// }
