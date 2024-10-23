import 'package:app/blocs/blocs_exports.dart';
import 'package:app/cubits/cubits.dart';
import 'package:app/data/data.dart';
import 'package:app/screens/screens.dart';
import 'package:app/services/services.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CheckoutModel? checkoutModel;

  @override
  void initState() {
    getCheckout();
    super.initState();
  }

  void getCheckout() {
    var readLocation = context.read<CurrentLocationCubit>();
    var checkoutBloc = context.read<CheckoutBloc>();

    // call get data event
    checkoutBloc.add(FetchCheckoutDataEvent(
        cartId: context.read<CartBloc>().cartResDataModel!.id,
        customerID: context.read<ProfileBloc>().userModel.id,
        lat: readLocation.position!.latitude.toString(),
        lon: readLocation.position!.longitude.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutLoadingState) {
          EasyLoading.show();
        }

        if (state is CheckoutLoadedState) {
          checkoutModel = state.model;
          setState(() {});
          EasyLoading.dismiss();
        }
        if (state is CheckoutErrorState) {
          EasyLoading.dismiss();
          showToast(context, state);
        }
      },
      builder: (context, state) {
        var address = context.read<CurrentLocationCubit>().selectedAddress;
        return Scaffold(
          backgroundColor: AppColors.kMainBlue,
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  CustomHeaderWidget(buildContext: context),
                  const SizedBox(height: 10),
                  Row(children: [
                    InkWell(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.navigate_before_rounded,
                            color: Colors.white)),
                    const SizedBox(width: 8),
                    const CustomTextWidget(
                        text: 'My Cart',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)
                  ]),
                  const SizedBox(height: 10),

                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextWidget(
                                text: "Billing Address",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.kBlue3),
                            CustomTextWidget(
                              text:
                                  "${address.addressLine1},${address.district}",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.kBlue2),
                              onPressed: () async {
                                var response = await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Dialog(
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    backgroundColor: AppColors.kBlue1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const ChangeAddressWidget(),
                                  ),
                                );

                                if (response != null && response) {
                                  setState(() {
                                    getCheckout();
                                  });
                                }
                              },
                              child: const CustomTextWidget(
                                text: "Change",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ]),

                  const SizedBox(height: 20),

                  // checkout item builder
                  checkoutModel == null
                      ? AspectRatio(
                          aspectRatio: 1,
                          child: ColoredBox(
                              color: AppColors.kBlue1.withOpacity(0.5),
                              child: const Center(
                                  child: CircularProgressIndicator())))
                      : ListView.builder(
                          itemCount: checkoutModel!.cart.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => CheckoutItem(
                                cartItem: checkoutModel!.cart[index],
                                currency: checkoutModel!.currency,
                                isExpanded: checkoutModel!.cart.length == 1
                                    ? true
                                    : false,
                              )),

                  const SizedBox(height: 15),

                  checkoutModel == null
                      ? const SizedBox()
                      : CustomOrderSummeryCardWidget(
                          cart: checkoutModel!.cart,
                          currency: '${checkoutModel!.currency}.',
                          shippingCost: checkoutModel!.shippingCost),
                  const SizedBox(height: 25),
                  CustomGradientButton(
                      onPressed: () => context.push(AppRoutes.selectPayment),
                      width: double.infinity,
                      height: 45,
                      text: "Proceed to Pay"),
                  const SizedBox(height: 25),
                ],
              )),
            ),
          ),
        );
      },
    );
  }

  void showToast(BuildContext context, CheckoutErrorState state) {
    context.read<ToastBloc>().add(
        MakeToastEvent(message: state.error, context: context, inShell: false));
  }
}

class ChangeAddressWidget extends StatefulWidget {
  const ChangeAddressWidget({
    super.key,
  });

  @override
  State<ChangeAddressWidget> createState() => _ChangeAddressWidgetState();
}

class _ChangeAddressWidgetState extends State<ChangeAddressWidget> {
  late List<Address> addressList;
  late CurrentLocationCubit read;
  late Address address;

  bool isLoading = true;

  @override
  void initState() {
    fetchLocation();
    super.initState();
  }

  void fetchLocation() async {
    read = context.read<CurrentLocationCubit>();
    addressList = context.read<ProfileBloc>().userModel.addressList;
    addressList.sort((a, b) => a.created.compareTo(b.created));
    await read.getLocation(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentLocationCubit, CurrentLocationState>(
      listener: (context, state) {
        if (state is CurrentLocationLoadingState) {
          isLoading = true;
        }
        if (state is CurrentLocationUpdatedState) {
          address = state.address;

          isLoading = false;
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomTextWidget(
                  text: "Change billing address",
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    color: AppColors.kBlue2,
                    borderRadius: BorderRadius.circular(15)),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : addressList.isEmpty
                        ? AspectRatio(
                            aspectRatio: 1.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AssestPath.emptyIcon),
                                const SizedBox(height: 10),
                                const CustomTextWidget(
                                    text: 'Address not found..',
                                    color: Colors.white,
                                    fontSize: 14),
                              ],
                            ))
                        : ListView.builder(
                            itemCount: addressList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                read.selectedAddress.id == addressList[index].id
                                    ? read.unsaveLocation(context: context)
                                    : read.setLocation(
                                        address: addressList[index]);
                              },
                              child: RecentLocationListItem(
                                address: addressList[index],
                                selectedAddress: address,
                                showRemoveBtn: false,
                              ),
                            ),
                          ),
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
                    child: const CustomTextWidget(text: 'No', fontSize: 20)),
              )
            ],
          ),
        );
      },
    );
  }
}

class CheckoutItem extends StatefulWidget {
  const CheckoutItem({
    super.key,
    required this.cartItem,
    required this.currency,
    required this.isExpanded,
  });

  final Cart cartItem;
  final String currency;
  final bool isExpanded;

  @override
  State<CheckoutItem> createState() => _CheckoutItemState();
}

class _CheckoutItemState extends State<CheckoutItem> {
  final ExpansionTileController controller = ExpansionTileController();
  bool _isExpanded = false;
  double calSubTotal() {
    var totalDisc = 0.0;
    var totalTax = 0.0;
    var totalItemCost = 0.0;
    for (var discItem in widget.cartItem.discountList) {
      totalDisc += discItem.amount;
    }

    for (var taxItem in widget.cartItem.taxList) {
      totalTax += taxItem.amount;
    }

    for (var item in widget.cartItem.items) {
      totalTax += item.lineTotal;
    }

    return (totalItemCost + totalTax) - totalDisc;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: AppColors.kBlue1.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                  initiallyExpanded: widget.isExpanded,
                  controller: controller,
                  onExpansionChanged: (value) {
                    setState(() {
                      _isExpanded = value;
                    });
                  },
                  childrenPadding: EdgeInsets.zero,
                  backgroundColor: AppColors.kBlue1,
                  collapsedBackgroundColor: AppColors.kBlue1,
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  trailing: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: CustomTextWidget(
                        text: widget.cartItem.shopName,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  subtitle: _isExpanded
                      ? null
                      : Row(
                          children: [
                            CustomTextWidget(
                                text: widget.cartItem.items.length > 1
                                    ? "${widget.cartItem.items.length} items"
                                    : "1 item",
                                fontSize: 14,
                                color: AppColors.kGray1),
                            const SizedBox(width: 10),
                            CustomTextWidget(
                                text:
                                    "·  ${ValidationService().formatPriceWithCurrency(calSubTotal(), widget.currency)}",
                                fontSize: 14,
                                color: AppColors.kGray1),
                          ],
                        ),
                  children: <Widget>[
                    const ItemText(itemName: 'Items -'),
                    ShopItemListBuilder(
                      cartItem: widget.cartItem,
                      currency: widget.currency,
                    ),
                    Visibility(
                        visible: widget.cartItem.taxList.isNotEmpty,
                        child: const ItemText(itemName: 'Taxes -')),
                    Visibility(
                        visible: widget.cartItem.taxList.isNotEmpty,
                        child: ShopTaxesListBuilder(
                            cartItem: widget.cartItem,
                            currency: widget.currency)),
                    Visibility(
                        visible: widget.cartItem.discountList.isNotEmpty,
                        child: const ItemText(itemName: 'Discounts -')),
                    Visibility(
                        visible: widget.cartItem.discountList.isNotEmpty,
                        child: ShopDiscountListBuilder(
                            cartItem: widget.cartItem,
                            currency: widget.currency)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 1,
                              child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: CustomTextWidget(
                                      text: "Subtotal",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                          const SizedBox(width: 15),
                          Expanded(
                              flex: 1,
                              child: FittedBox(
                                  alignment: Alignment.centerRight,
                                  fit: BoxFit.scaleDown,
                                  child: CustomTextWidget(
                                      text: ValidationService()
                                          .formatPriceWithCurrency(
                                              calSubTotal(), widget.currency),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)))
                        ],
                      ),
                    )
                  ])),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              height: 35,
              child: ElevatedButton(
                  onPressed: () {
                    controller.isExpanded
                        ? controller.collapse()
                        : controller.expand();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      backgroundColor: AppColors.kBlue1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: CustomTextWidget(
                      text: _isExpanded ? "Show Less" : 'View Item',
                      fontSize: 12)))
        ],
      ),
    );
  }
}

class ShopDiscountListBuilder extends StatelessWidget {
  const ShopDiscountListBuilder({
    super.key,
    required this.cartItem,
    required this.currency,
  });

  final Cart cartItem;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 15, bottom: 10),
        child: Column(
            children: List.generate(
                cartItem.discountList.length,
                (index) => Row(children: [
                      Expanded(
                          flex: 1,
                          child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: CustomTextWidget(
                                  color: AppColors.kGray1,
                                  text: cartItem.discountList[index].name,
                                  fontSize: 16))),
                      const SizedBox(width: 15),
                      Expanded(
                          flex: 1,
                          child: FittedBox(
                              alignment: Alignment.centerRight,
                              fit: BoxFit.scaleDown,
                              child: CustomTextWidget(
                                  color: AppColors.kGray1,
                                  text: ValidationService()
                                      .formatPriceWithCurrency(
                                          cartItem.discountList[index].amount
                                              .toDouble(),
                                          currency),
                                  fontSize: 16)))
                    ]))));
  }
}

class ItemText extends StatelessWidget {
  const ItemText({
    super.key,
    required this.itemName,
  });

  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 2),
        child: Align(
            alignment: Alignment.centerLeft,
            child: CustomTextWidget(
                text: itemName,
                fontSize: 16,
                color: Colors.white.withOpacity(0.7))));
  }
}

class ShopTaxesListBuilder extends StatelessWidget {
  const ShopTaxesListBuilder({
    super.key,
    required this.cartItem,
    required this.currency,
  });

  final Cart cartItem;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 15, bottom: 10),
        child: Column(
            children: List.generate(
                cartItem.taxList.length,
                (index) => Row(children: [
                      Expanded(
                          flex: 1,
                          child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: CustomTextWidget(
                                  color: AppColors.kGray1,
                                  text: cartItem.taxList[index].name,
                                  fontSize: 16))),
                      const SizedBox(width: 15),
                      Expanded(
                          flex: 1,
                          child: FittedBox(
                              alignment: Alignment.centerRight,
                              fit: BoxFit.scaleDown,
                              child: CustomTextWidget(
                                  color: AppColors.kGray1,
                                  text: ValidationService()
                                      .formatPriceWithCurrency(
                                          cartItem.taxList[index].amount
                                              .toDouble(),
                                          currency),
                                  fontSize: 16)))
                    ]))));
  }
}

class ShopItemListBuilder extends StatelessWidget {
  const ShopItemListBuilder({
    super.key,
    required this.cartItem,
    required this.currency,
  });

  final Cart cartItem;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 15, bottom: 10),
        child: Column(
            children: List.generate(
                cartItem.items.length,
                (index) => Row(children: [
                      Expanded(
                          flex: 1,
                          child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: CustomTextWidget(
                                  color: AppColors.kGray1,
                                  text: cartItem.items[index].productName,
                                  fontSize: 16))),
                      const SizedBox(width: 15),
                      Expanded(
                          flex: 1,
                          child: FittedBox(
                              alignment: Alignment.centerRight,
                              fit: BoxFit.scaleDown,
                              child: CustomTextWidget(
                                  color: AppColors.kGray1,
                                  text: ValidationService()
                                      .formatPriceWithCurrency(
                                          cartItem.items[index].price
                                              .toDouble(),
                                          currency),
                                  fontSize: 16)))
                    ]))));
  }
}
