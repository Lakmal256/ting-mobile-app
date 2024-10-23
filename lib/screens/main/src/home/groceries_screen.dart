import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:flutter/material.dart';

import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../blocs/blocs_exports.dart';
import '../../../../cubits/cubits.dart';
import '../../../../data/models/marketplace/banners_model.dart';

class GroceriesScreen extends StatefulWidget {
  final List<BannersModel> bannersList;
  const GroceriesScreen({super.key, required this.bannersList});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
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
        address: location.selectedAddress, department: "Groceries"));
    context.read<CartBloc>().add(CartFetchDataEvent(
        customerId: context.read<ProfileBloc>().userModel.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoadingState) {
          isLoading = true;
        }

        if (state is HomeDateErrorState) {
          isLoading = true;
          context.read<ToastBloc>().add(
              MakeToastEvent(message: state.errorMessage, context: context));
        }

        if (state is HomeDataFetchSuccess) {
          isLoading = false;
          categoriesList = state.categoriesList;
        }

        if (state is HomeDataFilterdState) {}

        if (state is HomeDataFilterCleanState) {}
      },
      builder: (context, state) {
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
                                            text: "Groceries Products",
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
                                type: "Groceries Products",
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
                              // Categories
                              const GroceriesCategoryBuilder(
                                title: "Fruits",
                              ),
                            ],
                          ),
                        ),
                ),
              )),
        );
      },
    );
  }
}

class GroceriesCategoryBuilder extends StatelessWidget {
  final String title;
  const GroceriesCategoryBuilder({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomTextWidget(
                        text: title, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {},
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomTextWidget(
                        text: "View more..",
                        fontSize: 15,
                        color: AppColors.kBlue3,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: FlipEffect.defaultAxis,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 6,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20.0),
              itemBuilder: (context, index) => CustomProductCardWidget(
                    product: null,
                    onTap: () {},
                  )),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.15,
          )
        ],
      ),
    );
  }
}
