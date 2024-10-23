// ignore_for_file: use_build_context_synchronously
import 'package:app/cubits/cubits.dart';
import 'package:app/data/models/marketplace/banners_model.dart';
import 'package:app/screens/main/src/home/groceries_screen.dart';
import 'package:app/services/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:app/screens/screens.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CarouselController carouselController = CarouselController();
  PageController pageController = PageController();

  bool isLoading = true;
  bool filterVendros = false;

  late List<ShopTypeModel> departmentList;
  late List<CategoriesModel> categoriesList;
  late List<VendorsModel> sampleVendorData;
  late List<BannersModel> bannersList;

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
    context.read<HomeBloc>().add(HomeFetchDataEvent(
        address: location.selectedAddress, department: "Restaurants"));
    context.read<CartBloc>().add(CartFetchDataEvent(
        customerId: context.read<ProfileBloc>().userModel.id));
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.read<ProfileBloc>().userModel;

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
          departmentList = state.shopTypeList;
          categoriesList = state.categoriesList;
          sampleVendorData = state.vendorsList;
          bannersList = state.bannersList;
          isLoading = false;
        }

        if (state is HomeDataFilterdState) {
          sampleVendorData = state.filteredVendorsList;
          filterVendros = true;
        }

        if (state is HomeDataFilterCleanState) {
          sampleVendorData = state.filteredVendorsList;
          filterVendros = false;
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.kMainBlue,
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Stack(
                    children: [
                      // Background image
                      Positioned(
                          top: 80,
                          left: 0,
                          right: 0,
                          child: SvgPicture.asset(
                              "assets/backgrounds/home_background.svg",
                              fit: BoxFit.fill)),
                      isLoading
                          ? SizedBox(
                              width: double.infinity,
                              height: MediaQuery.sizeOf(context).height,
                              child: const Center(
                                  child: CircularProgressIndicator()))
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.05),
                                      CustomHeaderWidget(
                                        buildContext: context,
                                        onChange: fetchHomeData,
                                      ),
                                      const SizedBox(height: 20),
                                      // greeting line
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                  text:
                                                      "Hey ${userModel.firstName}",
                                                  fontSize: 16,
                                                  textAlign: TextAlign.left),
                                              const CustomTextWidget(
                                                  text: "Good Morning!",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  textAlign: TextAlign.left),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20),
                                      // search bar

                                      const CustomSearchTextWidget(
                                        tappable: false,
                                        searchView: null,
                                        currentSearchTerm: '',
                                      ),

                                      const SizedBox(height: 20.0),

                                      // departments
                                      const Align(
                                          alignment: Alignment.centerLeft,
                                          child: CustomTextWidget(
                                              text: "Departments",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),

                                      const SizedBox(height: 20),
                                      AspectRatio(
                                        // department item builder
                                        aspectRatio: 3.7,
                                        child: Row(
                                            children: List.generate(
                                                departmentList.length,
                                                (index) => DepartmentWidget(
                                                      shopTypeModel:
                                                          departmentList[index],
                                                      bannersList: bannersList,
                                                      onHandler: _handleRefresh,
                                                    ))),
                                      ),

                                      const SizedBox(height: 20),

                                      // Categories
                                      const Align(
                                          alignment: Alignment.centerLeft,
                                          child: CustomTextWidget(
                                              text: "Categories",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      // category item builder
                                      CustomCategoriesScrollWidget(
                                        categoryList: categoriesList,
                                        onSelect: (name) => context
                                            .read<HomeBloc>()
                                            .add(HomeFilterByCategoryEvent(
                                                categoryName: name)),
                                      ),

                                      const SizedBox(height: 20),

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

                                      const SizedBox(height: 35),

                                      filterVendros
                                          ? FiltertedVendorsView(
                                              vendorsList: sampleVendorData)
                                          : DefaultView(
                                              sampleVendorData:
                                                  sampleVendorData,
                                              bannersList: bannersList,
                                            ),

                                      const SafeArea(child: SizedBox())
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}

class DefaultView extends StatefulWidget {
  const DefaultView({
    super.key,
    required this.sampleVendorData,
    required this.bannersList,
  });

  final List<VendorsModel> sampleVendorData;
  final List<BannersModel> bannersList;

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {
  final List<VendorsModel> featuredVendorList = [];
  final List<VendorsModel> mostLikedVendorList = [];

  @override
  void initState() {
    featuredVendorList.addAll(widget.sampleVendorData
        .where((element) => element.isFeatured == true)
        .toList());
    mostLikedVendorList.addAll(widget.sampleVendorData
        .where((element) => element.isRecommended == true)
        .toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Packaging & Offers
        const Align(
            alignment: Alignment.centerLeft,
            child: CustomTextWidget(
                text: "Packages & Offers",
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        CustomOffersSliderWidget(
          bannersList: widget.bannersList,
        ),

        const SizedBox(height: 20),

        // near by resturnets for user
        featuredVendorList.isNotEmpty
            ? const Align(
                alignment: Alignment.centerLeft,
                child: CustomTextWidget(
                    text: "Featured Restaurants",
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
            : Container(),

        const SizedBox(height: 20),
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: featuredVendorList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => CustomNearbyResturantsWidget(
                  index: index,
                  restaurantType: RestaurantType.featured,
                  shopName: featuredVendorList[index].name,
                  bannerImage: featuredVendorList[index].bannerImage,
                  deliveryTime: featuredVendorList[index].deliveryTime,
                  distance: featuredVendorList[index].distance,
                  rating: featuredVendorList[index].rating,
                  deliveryFee: featuredVendorList[index].priceRange,
                )),

        // near by resturnets for user
        mostLikedVendorList.isNotEmpty
            ? const Align(
                alignment: Alignment.centerLeft,
                child: CustomTextWidget(
                    text: "Most Liked Restaurants",
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
            : Container(),

        const SizedBox(height: 20),
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: mostLikedVendorList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => CustomNearbyResturantsWidget(
                  index: index,
                  restaurantType: RestaurantType.featured,
                  shopName: mostLikedVendorList[index].name,
                  bannerImage: mostLikedVendorList[index].bannerImage,
                  deliveryTime: mostLikedVendorList[index].deliveryTime,
                  distance: mostLikedVendorList[index].distance,
                  rating: mostLikedVendorList[index].rating,
                  deliveryFee: mostLikedVendorList[index].priceRange,
                )),

        // frequently orderd slider
        const CustomeCarouselSliderWidget(),

        const SizedBox(height: 30),

        // Top Brands
        const Align(
            alignment: Alignment.centerLeft,
            child: CustomTextWidget(
                text: "All Restaurants",
                fontSize: 20,
                fontWeight: FontWeight.bold)),

        const SizedBox(height: 15),
        AllResturantsListBuilder(sampleVendorData: widget.sampleVendorData),
        const SizedBox(height: 20),
      ],
    );
  }
}

class AllResturantsListBuilder extends StatelessWidget {
  const AllResturantsListBuilder({
    super.key,
    required this.sampleVendorData,
  });

  final List<VendorsModel> sampleVendorData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: sampleVendorData.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20, mainAxisSpacing: 2, crossAxisCount: 2),
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  context
                      .read<VendorsBloc>()
                      .add(VendorItemTapEvent(vendor: sampleVendorData[index]));

                  context.go(AppRoutes.vendor);
                },
                child: VenderInfoCardWidget(
                    showInHome: true, vendorsModel: sampleVendorData[index]),
              )),
    );
  }
}

class DepartmentWidget extends StatelessWidget {
  final Function() onHandler;
  final ShopTypeModel shopTypeModel;
  final List<BannersModel> bannersList;

  const DepartmentWidget(
      {super.key,
      required this.shopTypeModel,
      required this.bannersList,
      required this.onHandler});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          if (shopTypeModel.name.contains('Wine & Spirits')) {
            context.go(AppRoutes.liquor);
          } else if (shopTypeModel.name.contains('Restaurants')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DepartmentScreen(
                          bannersList: bannersList,
                        ))).then((val) {
              onHandler();
            });
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroceriesScreen(
                          bannersList: bannersList,
                        ))).then((val) {
              onHandler();
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.kMainBlue.withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.scaleDown,
                      width: 10,
                      imageUrl: shopTypeModel.icon,
                    ),
                  ),
                ),
              ),
              FittedBox(
                child: CustomTextWidget(text: shopTypeModel.name, fontSize: 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomeCarouselSliderWidget extends StatefulWidget {
  const CustomeCarouselSliderWidget({super.key});

  @override
  State<CustomeCarouselSliderWidget> createState() =>
      _CustomeCarouselSliderWidgetState();
}

class _CustomeCarouselSliderWidgetState
    extends State<CustomeCarouselSliderWidget> {
  int _currentIndex = 0;

  final List<String> imgList = [
    'https://thumbs.dreamstime.com/b/heart-shape-various-vegetables-fruits-healthy-food-concept-isolated-white-background-140287808.jpg',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8fA%3D%3D',
    'https://media.istockphoto.com/id/1322628932/photo/poke-bowl-with-salmon-avocado-quinoa-and-cucumber.jpg?s=612x612&w=0&k=20&c=dxyEXDzNYYjmKfNzi6QegEJQTbE-1jZZB4HtQKQABhs=',
    'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP3j1MwUqd4oSYxZqLWkHlRBUykorOnBMXeQ&usqp=CAU',
    'https://img.bestrecipes.com.au/GmWTemLJ/w643-h428-cfill-q90/br/2019/02/1980-crunchy-chicken-twisties-drumsticks-951509-1.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: CustomTextWidget(
              text: 'Order Again', fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        CarouselSlider(
          items: imgList
              .map(
                (item) => Container(
                  decoration: const BoxDecoration(
                      color: AppColors.kBlue2,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Center(
                    child: Row(children: [
                      // carousel image
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(ProductDetailsScreen.id),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.kBlue2,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                image: DecorationImage(
                                    image: NetworkImage(item),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // text detail area
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomTextWidget(
                            text: 'Tom Yum Soup',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const CustomTextWidget(
                              text: 'Nara thai - 5km Away',
                              color: AppColors.kGray2,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                          const SizedBox(height: 10),
                          const CustomTextWidget(
                              text:
                                  'The name “tom yam” is\ncomposed of two Thai\nwords. Tom refers to...',
                              color: AppColors.kGray2,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CustomTextWidget(
                                text: 'Rs. 3,200.00',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: AppColors.kBlue3,
                                    borderRadius: BorderRadius.circular(14)),
                                child: const Center(
                                    child: CustomTextWidget(
                                  text: "Add",
                                  fontSize: 13,
                                )),
                              )
                            ],
                          )
                        ],
                      )
                    ]),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 18 / 8,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
              padEnds: false),
        ),
        const SizedBox(height: 10),
        CarouselIndicator(index: _currentIndex, count: imgList.length)
      ],
    );
  }
}

class FiltertedVendorsView extends StatelessWidget {
  const FiltertedVendorsView({
    super.key,
    required this.vendorsList,
  });
  final List<VendorsModel> vendorsList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomTextWidget(
              text: '${vendorsList.length} results',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          AllResturantsListBuilder(sampleVendorData: vendorsList),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class VenderInfoCardWidget extends StatelessWidget {
  const VenderInfoCardWidget({
    super.key,
    required this.vendorsModel,
    this.showInHome = false,
  });
  final VendorsModel vendorsModel;

  final bool showInHome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Card(
        color: Colors.white.withOpacity(0.07),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
              aspectRatio: 16 / 11,
              child: Column(children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: FittedBox(
                      fit: BoxFit.cover,
                      child: CustomNetworkImage(
                          imageUrl: vendorsModel.bannerImage)),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Padding(
                      padding: showInHome
                          ? const EdgeInsets.symmetric(horizontal: 10)
                          : const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        showInHome
                            ? const SizedBox.shrink()
                            : SizedBox(
                                width: 45,
                                child: CustomNetworkImage(
                                    imageUrl: vendorsModel.bannerImage)),
                        showInHome
                            ? const SizedBox.shrink()
                            : const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: CustomTextWidget(
                                        text:
                                            vendorsModel.name.split('-').first,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(children: [
                                    showInHome
                                        ? const SizedBox.shrink()
                                        : Icon(Icons.timelapse_sharp,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                    const SizedBox(width: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: CustomTextWidget(
                                          text: '25 - 30 min',
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white.withOpacity(0.5)),
                                    )
                                  ])
                                ],
                              ),
                              const SizedBox(width: 4),
                              const Spacer(),
                              // right end
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(AssestPath.assetLikeIconPath,
                                      width: 15),
                                  const SizedBox(width: 5),
                                  CustomTextWidget(
                                    text: '${vendorsModel.votes ?? '0'}',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                )
              ])),
        ),
      ),
    );
  }
}
