// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:app/data/models/models.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartResModel? cartDataModel;

  @override
  void initState() {
    _handleRefresh();
    super.initState();
  }

  Future<void> _handleRefresh() async {
    context.read<CartBloc>().add(CartFetchDataEvent(
        customerId: context.read<ProfileBloc>().userModel.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(listener: (context, state) {
      log("Cart State changed ${state.runtimeType}");
      if (state is CartLoadingState) {
        // EasyLoading.show();
      }
      if (state is CartErrorState) {
        // EasyLoading.isShow ? EasyLoading.dismiss() : null;
        context
            .read<ToastBloc>()
            .add(MakeToastEvent(message: state.message, context: context));
      }

      if (state is CartLoadedState) {
        cartDataModel = state.cartResModel;
        // EasyLoading.isShow ? EasyLoading.dismiss() : null;
      }

      if (state is CartUpdatedState) {
        context.read<CartBloc>().add(CartFetchDataEvent(
            customerId: context.read<ProfileBloc>().userModel.id));
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.kMainBlue,
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeaderWidget(buildContext: context),
                      const SizedBox(height: 15),
                      const CustomTextWidget(
                          text: 'My Cart',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomTextWidget(
                              text: 'Order Details',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kBlue3),
                          ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: AppColors.kBlue2),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              label: const CustomTextWidget(
                                  text: 'Add more',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      cartDataModel == null || cartDataModel!.items.isEmpty
                          ? const EmptyCartView()
                          : Expanded(
                              child: Padding(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: cartDataModel!.items.length,
                                  itemBuilder: (context, index) =>
                                      CartItemWidget(
                                          item: cartDataModel!.items[index])),
                            )),
                    ],
                  ),
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Visibility(
                      visible: cartDataModel != null &&
                          cartDataModel!.items.isNotEmpty,
                      child: CustomGradientButton(
                          onPressed: () {
                            context.push(AppRoutes.checkout);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const OrderStatusScreen()));
                          },
                          width: double.infinity,
                          height: 45,
                          text: "Checkout!"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.kBlue1, borderRadius: BorderRadius.circular(12)),
      child: AspectRatio(
          aspectRatio: 1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AssestPath.emptyIcon),
                const SizedBox(height: 15),
                const CustomTextWidget(
                    text: "Your cart is empty..", fontSize: 12)
              ])),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({
    super.key,
    required this.item,
  });
  final Item item;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late int price;
  late int qty;

  @override
  Widget build(BuildContext context) {
    qty = widget.item.qty;
    price = widget.item.price * qty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: AppColors.kBlue1,
        child: AspectRatio(
          aspectRatio: 10 / 3,
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                          height: double.infinity,
                          fit: BoxFit.fill,
                          imageUrl:
                              'https://cdn.britannica.com/98/235798-050-3C3BA15D/Hamburger-and-french-fries-paper-box.jpg'),
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 0,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CustomTextWidget(
                              text: widget.item.productName,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            const CustomTextWidget(
                              text: 'Shop Name',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              AssestPath.thumbesUpIcon,
                              fit: BoxFit.cover,
                              width: 15,
                            ),
                            const SizedBox(width: 5),
                            const CustomTextWidget(
                              text: '45',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Visibility(
                          visible: !widget.item.isFreeItem,
                          replacement: const SizedBox(height: 25),
                          child: CustomTextWidget(
                            text: ValidationService()
                                .formatPrice(price.toDouble() * qty),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(height: 10)
                      ])),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5, top: 5),
                        child: Visibility(
                          visible: !widget.item.isFreeItem,
                          replacement: const SizedBox(),
                          child: Transform.scale(
                            scale: 0.8,
                            child: IconButton(
                                splashColor: Colors.white,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                                onPressed: () => deleteItem(item: widget.item),
                                icon: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Visibility(
                        visible: !widget.item.isFreeItem,
                        replacement: const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: CustomTextWidget(
                            text: "FREE",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        child: Transform.scale(
                            alignment: Alignment.bottomRight,
                            scale: 0.7,
                            child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                width: MediaQuery.sizeOf(context).width / 4,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                    color: AppColors.kBlue2,
                                    borderRadius: BorderRadius.circular(22)),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 0,
                                          child: IconButton(
                                              splashColor: AppColors.kMainBlue,
                                              disabledColor:
                                                  Colors.white.withOpacity(0.5),
                                              color: Colors.white,
                                              padding: EdgeInsets.zero,
                                              style: IconButton.styleFrom(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap),
                                              onPressed: () => updateQty(
                                                  currentQty: qty,
                                                  type: Quantity.minus,
                                                  context: context),
                                              icon: const Icon(Icons.remove))),
                                      Expanded(
                                          flex: 1,
                                          child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: CustomTextWidget(
                                                  text: "$qty",
                                                  fontSize: 16,
                                                  color: AppColors.kGray2,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 0,
                                          child: IconButton(
                                              splashColor: AppColors.kMainBlue,
                                              disabledColor:
                                                  Colors.white.withOpacity(0.5),
                                              color: Colors.white,
                                              padding: EdgeInsets.zero,
                                              style: IconButton.styleFrom(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap),
                                              onPressed: () => updateQty(
                                                  currentQty: qty,
                                                  type: Quantity.plus,
                                                  context: context),
                                              icon: const Icon(Icons.add))),
                                    ]))),
                      ),
                      const SizedBox(height: 10)
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void deleteItem({required Item item}) async {
    var resposne = await showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: const BoxDecoration(
              color: AppColors.kBlue1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const Icon(Icons.production_quantity_limits_outlined,
                      color: Colors.white, size: 30),
                  const SizedBox(height: 5),
                  const CustomTextWidget(
                    text: "Are you sure you want to remove this item?",
                    fontSize: 18,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  CustomGradientButton(
                      onPressed: () => context.pop(true),
                      width: double.infinity,
                      height: 40,
                      text: 'Yes'),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: AppColors.kMainBlue),
                        onPressed: () => context.pop(false),
                        child:
                            const CustomTextWidget(text: 'No', fontSize: 20)),
                  )
                ],
              ),
            ));
      },
    );

    if (resposne) {
      context.read<CartBloc>().add(CartDeleteItemEvent(
          item: item, customerId: context.read<ProfileBloc>().userModel.id));
    }
  }

  void updateQty(
      {required int currentQty,
      required Quantity type,
      required BuildContext context}) {
    type == Quantity.plus
        ? qty++
        : qty == 1
            ? 1
            : qty--;
    if (qty != 1 || currentQty != 1) {
      context.read<CartBloc>().add(CartUpdateEvent(
          customerId: context.read<ProfileBloc>().userModel.id,
          updatedItem: widget.item.copyWith(qty: qty)));
    }
  }
}
