import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VendorViewScreen extends StatefulWidget {
  const VendorViewScreen({super.key});

  @override
  State<VendorViewScreen> createState() => _VendorViewScreenState();
}

class _VendorViewScreenState extends State<VendorViewScreen> {
  bool loading = true;
  int currentMenuIndex = 0;
  late VendorsMenuModel menuModel;
  final ScrollController controller = ScrollController();
  late VendorsModel vendorModel;
  late VendorProfileModel profileModel;

  @override
  void initState() {
    vendorModel = context.read<VendorsBloc>().selectedVendorModel;
    context.read<VendorsBloc>().add(VendorGetMenusEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VendorsBloc, VendorsState>(
      listener: (context, state) {
        if (state is ShopProductLoadingState) {
          loading = true;
        }
        if (state is VendorGetMenuSuccessState) {
          menuModel = state.menuModel;
          profileModel = state.profileModel;
          loading = false;
        }
        if (state is VendorErrorState) {
          loading = false;
          EasyLoading.isShow ? EasyLoading.dismiss() : null;
          context.read<ToastBloc>().add(MakeToastEvent(
                message: state.error,
                context: context,
              ));
        }

        if (state is VendorPorductViewState) {
          EasyLoading.isShow ? EasyLoading.dismiss() : null;
          context.push(AppRoutes.product, extra: state.prodcutInfoModel);
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.kMainBlue,
            body: Skeletonizer(
              enabled: loading,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    floating: false,
                    expandedHeight: 150,
                    flexibleSpace: FlexibleSpaceBar(
                      background: loading
                          ? Container(color: Colors.white)
                          : ImageHeader(
                              vendorModel: vendorModel,
                              profileModel: profileModel,
                            ),
                    ),
                    automaticallyImplyLeading: loading ? true : false,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          loading
                              ? Container(
                                  height: 50,
                                  width: double.infinity,
                                  color: Colors.white,
                                )
                              : ShopInfoRow(
                                  vendorModel: vendorModel,
                                  profileModel: profileModel),
                          const SizedBox(height: 20),
                          const CustomTextWidget(
                              text: "Best deals for you!",
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          const SizedBox(height: 8),
                          AspectRatio(
                            aspectRatio: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      vendorModel.bannerImage),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  loading
                      ? const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()))
                      : SliverStickyHeader(
                          sticky: true,
                          header: Container(
                            height: 65.0,
                            margin: const EdgeInsets.only(top: 10),
                            alignment: Alignment.centerLeft,
                            child: RawScrollbar(
                                trackColor: AppColors.kGray2.withOpacity(0.2),
                                thickness: 3,
                                thumbVisibility: true,
                                trackVisibility: true,
                                padding: const EdgeInsets.only(bottom: 6),
                                thumbColor: AppColors.kGray2,
                                controller: controller,
                                child: ListView.builder(
                                  controller: controller,
                                  itemCount: menuModel.menus.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentMenuIndex = index;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomTextWidget(
                                              text: menuModel.menus[index].name,
                                              fontSize: 18),
                                          menuModel.menus[index].availability
                                                  .first.startTime.isEmpty
                                              ? const SizedBox.shrink()
                                              : CustomTextWidget(
                                                  text:
                                                      "${menuModel.menus[index].availability.first.startTime} - ${menuModel.menus[index].availability.first.endTime}",
                                                  fontSize: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                          sliver: SliverToBoxAdapter(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minHeight: double.minPositive,
                                  maxHeight: double.infinity),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    menuModel.menus[currentMenuIndex].categories
                                            .isEmpty
                                        ? const EmptyProductsWidget()
                                        : MenuProductsBuilder(
                                            menuModel: menuModel,
                                            currentMenuIndex: currentMenuIndex),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ));
      },
    );
  }
}

class MenuProductsBuilder extends StatelessWidget {
  const MenuProductsBuilder({
    super.key,
    required this.menuModel,
    required this.currentMenuIndex,
  });

  final VendorsMenuModel menuModel;
  final int currentMenuIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: menuModel.menus[currentMenuIndex].categories.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = menuModel.menus[currentMenuIndex].categories[index];
        if (category.products.isEmpty) {
          return SizedBox.fromSize();
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTextWidget(
              text: category.name, fontSize: 25, fontWeight: FontWeight.bold),
          const SizedBox(height: 10),
          GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: category.products.length,
              shrinkWrap: true,
              scrollDirection: FlipEffect.defaultAxis,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 5.7,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 8.0),
              itemBuilder: (context, index) => CustomProductCardWidget(
                    product: category.products[index],
                    onTap: () {
                      EasyLoading.show(
                          dismissOnTap: false, status: "Loading..");
                      context.read<VendorsBloc>().add(VendorProductOnTapEvent(
                          productId: category.products[index].productId));
                    },
                  )),
          const SizedBox(height: 15)
        ]);
      },
    );
  }
}

class EmptyProductsWidget extends StatelessWidget {
  const EmptyProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 200,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AssestPath.emptyIcon),
              const SizedBox(height: 16),
              const CustomTextWidget(text: "Products not found!", fontSize: 15)
            ]));
  }
}

class ShopInfoRow extends StatelessWidget {
  const ShopInfoRow({
    super.key,
    required this.vendorModel,
    required this.profileModel,
  });

  final VendorsModel vendorModel;
  final VendorProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomTextWidget(
                    text: vendorModel.name.split("-").first,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.kBlue1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: const Row(
                  children: [
                    Icon(Icons.favorite_border, color: Colors.white, size: 15),
                    SizedBox(width: 4),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomTextWidget(
                            text: "Favorite",
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 5),

        // distant and location
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.5, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssestPath.locationIcon, width: 10),
                    const SizedBox(width: 4),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomTextWidget(
                            text: 'Nawala, Colombo |${profileModel.distance}',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AssestPath.durationIcon, width: 10),
                  const SizedBox(width: 4),
                  const Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomTextWidget(
                            text: '25 - 25 min  | LKR 300.00',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ImageHeader extends StatelessWidget {
  const ImageHeader({
    super.key,
    required this.vendorModel,
    required this.profileModel,
  });

  final VendorsModel vendorModel;
  final VendorProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            vendorModel.bannerImage)))),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(
                    Icons.navigate_before,
                    color: Colors.white,
                    size: 35,
                    shadows: [
                      Shadow(
                          blurRadius: 1,
                          color: Colors.black54,
                          offset: Offset(1, 3))
                    ],
                  ),
                  onPressed: () {
                    context.go(AppRoutes.home);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: BottomWidgets(
                profileModel: profileModel,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppColors.kMainBlue,
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.kMainOranage,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      CustomTextWidget(
                          text: vendorModel.ratingPct ?? "0", fontSize: 14)
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class BottomWidgets extends StatelessWidget {
  const BottomWidgets({
    super.key,
    required this.profileModel,
  });

  final VendorProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            splashColor: Colors.white,
            radius: 30,
            child: CircleAvatar(
                backgroundColor: AppColors.kMainBlue,
                child: SvgPicture.asset(AssestPath.gradientSearchIcon,
                    fit: BoxFit.cover)),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
              backgroundColor: AppColors.kMainBlue,
              child: SvgPicture.asset(AssestPath.gradientShearIcon,
                  fit: BoxFit.cover)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () =>
                context.push(AppRoutes.vendorInfo, extra: profileModel),
            child: CircleAvatar(
              backgroundColor: AppColors.kMainBlue,
              child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: SvgPicture.asset(AssestPath.gradientInfoIcon,
                      fit: BoxFit.cover)),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListBuilder extends StatelessWidget {
  const ProductListBuilder({
    super.key,
    required this.productList,
  });

  final List<ProductItem> productList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: productList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => CustomProductInfoCardWidget(
              productItem: productList[index],
              showVendor: false,
            ));
  }
}
