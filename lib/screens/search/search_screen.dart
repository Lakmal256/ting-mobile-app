// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubit_current_location/current_location_cubit.dart';
import 'package:app/data/data.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String id = 'search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double selectedDeliveryFee = 3; // Default selected delivery fee
  late List<CategoriesModel> dataModel;
  late List<VendorsModel?>? products;
  late List<String> recentSearches;
  bool isLoading = true;
  SearchView _view = SearchView.defultView;
  String currentSearchTerm = '';

  @override
  void initState() {
    _loadRecentSearches();
    super.initState();
  }

  void showDeliveryFeeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            return DeliveryFeeBottomSheet(
              selectedValue: selectedDeliveryFee,
              onChanged: (value) {
                selectedDeliveryFee = value;
                state(() {});
              },
            );
          },
        );
      },
    );
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final recentList = prefs.getStringList('recentSearches');
    if (recentList != null) {
      recentSearches = recentList;
    } else {
      recentSearches = [];
    }
  }

  void _saveRecentSearch(String searchTerm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the search term if it exists in the list
    recentSearches.removeWhere((element) => element == searchTerm);
    // Add the search term to the beginning of the list
    if (searchTerm.isNotEmpty) {
      recentSearches.insert(0, searchTerm);
    }
    // Limit the list to 4 items
    if (recentSearches.length > 4) {
      recentSearches.removeLast();
    }
    await prefs.setStringList('recentSearches', recentSearches);
  }

  Future<void> searchProduct(String searchTerm) async {
    var location = context.read<CurrentLocationCubit>();
    await location.getLocation(context: context);
    log("Address: ${location.selectedAddress.addressLine1}");
    context.read<SearchBloc>().add(SearchProductEvent(
        keyword: searchTerm, address: location.selectedAddress));
    setState(() {
      currentSearchTerm = searchTerm; // Update currentSearchTerm
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<SearchBloc>().add(FetchCategorySearchEvent());
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchViewCategorySuccessState) {
          dataModel = state.categoriesList;
          isLoading = false;
        }

        if (state is SearchViewUpdateState) {
          _view = state.view;
          _loadRecentSearches();
        }

        if (state is SearchProductsSuccessState) {
          products = state.model;
          isLoading = false;
        }

        if (state is SearchViewLoadingState) {
          isLoading = true;
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.kMainBlue,
            body: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height,
              decoration: _view == SearchView.defultView
                  ? const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AssestPath.assestBackgroundPath),
                          fit: BoxFit.fill))
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomSearchTextWidget(
                        tappable: true,
                        searchView: _view,
                        currentSearchTerm: currentSearchTerm),
                    const SizedBox(height: 20),
                    if (_view == SearchView.defultView) ...[
                      Expanded(
                        child: ListView(shrinkWrap: true, children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: CustomTextWidget(
                                text: 'All Categories',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : LayoutBuilder(
                                  builder: (context, constraints) =>
                                      GridView.builder(
                                          itemCount: dataModel.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5.0,
                                            mainAxisSpacing: 0.0,
                                          ),
                                          itemBuilder: (context, index) =>
                                              CustomSearchCardWidget(
                                                  text: dataModel[index].name,
                                                  iconUrl:
                                                      dataModel[index].icon,
                                                  onTap: () {
                                                    searchProduct(
                                                        dataModel[index].name);
                                                    _saveRecentSearch(
                                                        dataModel[index].name);
                                                  }
                                                  // onTap: () => Navigator.pushNamed(context, ViewProductsScreen.id)
                                                  )))
                        ]),
                      )
                    ],
                    if (_view == SearchView.recentView) ...[
                      Expanded(
                        child: ListView(shrinkWrap: true, children: [
                          const CustomTextWidget(
                              text: 'Recent',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kGray1),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                recentSearches.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          color: Colors.white),
                                      const SizedBox(width: 10),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: InkWell(
                                          onTap: () {
                                            searchProduct(
                                                recentSearches[index]);
                                            _saveRecentSearch(
                                                recentSearches[index]);
                                          },
                                          child: CustomTextWidget(
                                            text: recentSearches[index],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const CustomTextWidget(
                              text: 'All Categories',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kGray1),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                dataModel.length,
                                (index) => Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CachedNetworkImage(
                                        imageUrl: dataModel[index].icon,
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: TextButton(
                                        onPressed: () {
                                          searchProduct(dataModel[index].name);
                                          _saveRecentSearch(
                                              dataModel[index].name);
                                        },
                                        child: CustomTextWidget(
                                          text: dataModel[index].name,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                    if (_view == SearchView.resultView) ...[
                      // filteration
                      CustomFilterWidget(
                        selectedFilterOptionsList:
                            (selectedFilterOptionsList) =>
                                context.read<HomeBloc>().add(
                                      HomeVendorFilterEvent(
                                        selectedFilterOptionsList:
                                            selectedFilterOptionsList,
                                      ),
                                    ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextWidget(
                        text: '${products?.length} results',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: products?.length,
                          itemBuilder: (context, index) {
                            var product = products?[index];
                            return CustomNearbyResturantsWidget(
                              index: index,
                              restaurantType: RestaurantType.none,
                              shopName: product?.name,
                              bannerImage: product?.bannerImage,
                              deliveryTime: product?.deliveryTime,
                              distance: product?.distance,
                              rating: product?.rating,
                              deliveryFee: product?.priceRange,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DeliveryFeeBottomSheet extends StatefulWidget {
  final double selectedValue;
  final ValueChanged<double> onChanged;

  const DeliveryFeeBottomSheet(
      {super.key, required this.selectedValue, required this.onChanged});

  @override
  _DeliveryFeeBottomSheetState createState() => _DeliveryFeeBottomSheetState();
}

class _DeliveryFeeBottomSheetState extends State<DeliveryFeeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.kBlue1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.kGray2.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                      child: Icon(Icons.arrow_drop_down_outlined,
                          color: Colors.white))),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
              child: Text("Delivery Fee",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          const SizedBox(height: 10),
          if (widget.selectedValue == 9)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Over \$7+",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Under \$${widget.selectedValue.round()}",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\$3",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("\$5",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("\$7",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("\$7+",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 1,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: Slider(
                value: widget.selectedValue.round().toDouble(),
                onChanged: widget
                    .onChanged, // Use the onChanged callback from the parent
                min: 3,
                max: 9,
                divisions: 3,
                activeColor: Colors.white,
                inactiveColor: AppColors.kGray2,
                thumbColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
              child: CustomGradientFilterButton(
                  onPressed: () {}, width: 340, height: 40, text: "Apply")),
          const SizedBox(height: 10),
          Center(
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CustomGradinetTextWidget(text: "Cancel"))),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
