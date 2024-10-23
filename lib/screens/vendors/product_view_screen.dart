// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'dart:developer';

import 'package:app/services/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class ProductViewScreen extends StatelessWidget {
  ProductViewScreen({
    super.key,
    required this.prodcutInfoModel,
  });

  final ProductInfoModel prodcutInfoModel;

  int quantity = 1;
  double totalPrice = 0;
  bool addtoCartLoading = false;

  @override
  Widget build(BuildContext context) {
    /// saving the product info in the bloc
    var read = context.read<ProductsBloc>();
    totalPrice = prodcutInfoModel.price.toDouble();
    read.add(ProductStoreStateEvent(prodcutInfoModel: prodcutInfoModel));

    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductQuntityState) {
          quantity = state.value;
        }

        if (state is ProductPriceState) {
          totalPrice = state.price;
        }

        if (state is ProductEasyLoadingState) {
          EasyLoading.show();
        }

        if (state is ProductAddtoCartLoadingState) {
          addtoCartLoading = true;
        }

        if (state is ProductAddtoCartFinishState) {
          addtoCartLoading = false;
          context.pop();
        }

        if (state is ProductErrorState) {
          addtoCartLoading = false;
          context.read<ToastBloc>().add(MakeToastEvent(
              message: state.message, context: context, inShell: false));
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              backgroundColor: AppColors.kMainBlue,

              /// add to cart button
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.kGray1))),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 25),
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.kMainOranage,
                        AppColors.kMainPink
                      ]),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                    // call add to cart event here
                    onPressed: () {
                      read.add(ProductAddtoCartPressEvent(
                          customerId: context.read<ProfileBloc>().userModel.id,
                          instructions: "",
                          cartResDataModel:
                              context.read<CartBloc>().cartResDataModel));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      child: addtoCartLoading
                          ? const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 6,
                                strokeCap: StrokeCap.round,
                                backgroundColor: AppColors.kBlue3,
                                color: AppColors.kMainBlue,
                              ),
                            )
                          : CustomTextWidget(
                              text: totalText,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImage(prodcutInfoModel: prodcutInfoModel),
                  ProductInfoView(prodcutInfoModel: prodcutInfoModel),
                  Divider(
                      height: 2,
                      color: AppColors.kBlue1.withOpacity(0.4),
                      thickness: 5),
                  const SizedBox(height: 15),

                  /// Customization list builder
                  CustomizationBuilder(prodcutInfoModel: prodcutInfoModel),

                  /// aditional note text
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextWidget(
                            text: "Additional instructions",
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 10),
                        TextFormField(
                          style: CustomTextStyles.textStyleWhite_14,
                          maxLines: 4,
                          minLines: 2,
                          decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: AppColors.kMainGray,
                              hintText: "Add a note",
                              prefix: const SizedBox(width: 10),
                              hintStyle: CustomTextStyles.textStyleWhite_14,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4))),
                        ),
                        const SizedBox(height: 15),
                        QuentitySelectorButton(quantity: quantity),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ))),
        );
      },
    );
  }

  String get totalText {
    double value = quantity * totalPrice;

    String total = ValidationService().formatPrice(value);

    return "Add to $quantity cart • $total";
  }
}

class QuentitySelectorButton extends StatelessWidget {
  const QuentitySelectorButton({
    super.key,
    required this.quantity,
  });

  final int quantity;

  @override
  Widget build(BuildContext context) {
    var read = context.read<ProductsBloc>();
    return Container(
      width: MediaQuery.sizeOf(context).width / 4,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          color: AppColors.kGray2.withOpacity(0.2),
          borderRadius: BorderRadius.circular(22)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 0,
            child: IconButton(
                splashColor: AppColors.kBlue3,
                color: Colors.white,
                style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () => read.add(
                    const ProductQuentityButtonEvent(value: Quantity.minus)),
                icon: const Icon(Icons.remove)),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomTextWidget(
                  text: "$quantity",
                  fontSize: 14,
                  color: AppColors.kGray2,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
                splashColor: AppColors.kBlue3,
                color: Colors.white,
                style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () => read.add(
                    const ProductQuentityButtonEvent(value: Quantity.plus)),
                icon: const Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}

class CustomizationBuilder extends StatefulWidget {
  const CustomizationBuilder({
    super.key,
    required this.prodcutInfoModel,
  });

  final ProductInfoModel prodcutInfoModel;

  @override
  State<CustomizationBuilder> createState() => _CustomizationBuilderState();
}

class _CustomizationBuilderState extends State<CustomizationBuilder> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: widget.prodcutInfoModel.customizations.length,
          itemBuilder: (context, customizIndex) {
            /// current customization item
            var customization =
                widget.prodcutInfoModel.customizations[customizIndex];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      /// display customization group name
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CustomTextWidget(
                              text: customization.groupName,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),

                      /// text widget that display how many customization item can added
                      AddonCountTextWidget(customization: customization),
                      const SizedBox(height: 8),

                      /// list builder for customization item list

                      CustomizeListBuilder(customization: customization)
                    ],
                  ),
                ),
                Divider(
                    height: 2,
                    color: AppColors.kBlue1.withOpacity(0.4),
                    thickness: 5),
                const SizedBox(height: 20)
              ],
            );
          },
        ));
  }
}

class CustomizeListBuilder extends StatefulWidget {
  const CustomizeListBuilder({
    super.key,
    required this.customization,
  });

  final Customization customization;

  @override
  State<CustomizeListBuilder> createState() => _CustomizeListBuilderState();
}

class _CustomizeListBuilderState extends State<CustomizeListBuilder> {
  List<CustomizationModel> selectedGroupDetails = [];
  String? _selectedOnlyOne;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.customization.groupDetails.length,
      itemBuilder: (context, index) {
        final item = widget.customization.groupDetails[index];
        final isSelected = selectedGroupDetails
            .any((groupItem) => groupItem.groupDetails.id == item.id);
        final isEnabled = _getEnabledStatus(item, isSelected);

        return CustomizGroupListItem(
          customization: widget.customization,
          enable: isEnabled,
          index: index,
          onChange: (selectedItem) {
            if (isEnabled) {
              _handleSelectionChange(selectedItem, isSelected);
              // context.read<ProductsBloc>().add(ProductAddCustomizationEvent(
              //     customizationModel: selectedItem));
            }
          },
        );
      },
    );
  }

  bool _getEnabledStatus(GroupDetail item, bool isSelected) {
    if (widget.customization.multiSelect) {
      return selectedGroupDetails.length <
              widget.customization.maxSelectItems ||
          isSelected;
    } else {
      return _selectedOnlyOne == null || isSelected;
    }
  }

  void _handleSelectionChange(
      CustomizationModel selectedItem, bool isSelected) {
    if (isSelected) {
      selectedGroupDetails.removeWhere((groupItem) =>
          groupItem.groupDetails.id == selectedItem.groupDetails.id);
      if (!widget.customization.multiSelect) {
        _selectedOnlyOne = null;
      }
    } else {
      if (widget.customization.multiSelect) {
        if (selectedGroupDetails.length <=
            widget.customization.maxSelectItems) {
          selectedGroupDetails.add(selectedItem);
        }
      } else {
        selectedGroupDetails.add(selectedItem);
        _selectedOnlyOne = selectedItem.groupDetails.id;
      }
    }
    setState(() {});
    log("Item Changed $selectedGroupDetails");
  }
}

class AddonCountTextWidget extends StatelessWidget {
  const AddonCountTextWidget({
    super.key,
    required this.customization,
  });

  final Customization customization;

  @override
  Widget build(BuildContext context) {
    final bool multiSelect = customization.multiSelect;
    final int minSelectItems = customization.minSelectItems;
    final int maxSelectItems = customization.maxSelectItems;

    final String chooseText =
        multiSelect ? "choose up to $maxSelectItems" : "choose only one";

    final String asteriskText = minSelectItems == 0 ? " " : " *";

    return Row(
      children: [
        Expanded(
          flex: 0,
          child: CustomTextWidget(
            text: chooseText,
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.normal,
          ),
        ),
        Expanded(
          flex: 0,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CustomTextWidget(
              text: asteriskText,
              fontSize: minSelectItems == 0 ? 12 : 20,
              color: Colors.redAccent[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

typedef OnChange = void Function(CustomizationModel customizationModel);

class CustomizGroupListItem extends StatefulWidget {
  const CustomizGroupListItem({
    super.key,
    required this.customization,
    required this.index,
    required this.enable,
    required this.onChange,
  });

  final Customization customization;
  final bool enable;
  final int index;
  final OnChange onChange;

  @override
  State<CustomizGroupListItem> createState() => _CustomizGroupListItemState();
}

class _CustomizGroupListItemState extends State<CustomizGroupListItem> {
  bool checkedValue = false;
  int itemQuentity = 0;
  bool _quantityUpdated = false;

  @override
  Widget build(BuildContext context) {
    var read = context.read<ProductsBloc>();
    var groupId = widget.customization.groupId;
    var groupDetail = widget.customization.groupDetails[widget.index];
    var customizationModel = CustomizationModel(
        groupId: groupId, groupDetails: groupDetail, quantity: itemQuentity);

    if (!widget.enable) itemQuentity = 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          enabled: widget.enable,
          onTap: groupDetail.multiQuanty
              ? null
              : () {
                  setState(() {
                    checkedValue = !checkedValue;
                  });

                  read.add(ProductAddCustomizationEvent(
                      customizationModel: customizationModel));

                  widget.onChange(customizationModel);
                },
          splashColor: AppColors.kBlue3.withOpacity(0.2),
          leading: !groupDetail.multiQuanty
              ? Checkbox(
                  value: checkedValue,
                  side: const BorderSide(color: Colors.white),
                  checkColor: AppColors.kMainOranage,
                  onChanged: (value) {
                    checkedValue != value!;
                  })
              : null,
          title: CustomTextWidget(
              text: groupDetail.productName,
              fontSize: 16,
              color: !widget.enable ? AppColors.kGray1 : Colors.white,
              fontWeight: FontWeight.bold),
          subtitle: CustomTextWidget(
              text:
                  "+ ${ValidationService().formatPrice(groupDetail.price.toDouble())}",
              fontSize: 14,
              color: !widget.enable ? AppColors.kGray1 : Colors.white,
              fontWeight: FontWeight.normal),
          trailing: !groupDetail.multiQuanty
              ? null
              : ItemQuentitySelector(
                  itemQuentity: itemQuentity,
                  enable: widget.enable,
                  onPressMinus: () {
                    if (itemQuentity == 0) return;

                    setState(() {
                      itemQuentity--;
                    });

                    if (!_quantityUpdated) {
                      _quantityUpdated = true;
                      widget.onChange(customizationModel);
                    }

                    read.add(ProductAddCustomizationEvent(
                        customizationModel: CustomizationModel(
                            groupId: groupId,
                            groupDetails: groupDetail,
                            quantity: itemQuentity)));

                    // reset _quantityUpdated flag when quantity is set to 0
                    if (itemQuentity == 0) {
                      _quantityUpdated = false;
                      widget.onChange(customizationModel);
                    }
                  },
                  onPressPlus: () {
                    // limit the quentity from maximum quantity
                    if (itemQuentity == groupDetail.maxQuanty) return;

                    setState(() {
                      itemQuentity++;
                    });

                    if (!_quantityUpdated) {
                      _quantityUpdated = true;
                      widget.onChange(customizationModel);
                    }

                    read.add(ProductAddCustomizationEvent(
                        customizationModel: CustomizationModel(
                            groupId: groupId,
                            groupDetails: groupDetail,
                            quantity: itemQuentity)));

                    // reset _quantityUpdated flag when quantity is set to 0
                    if (itemQuentity == 0) {
                      _quantityUpdated = false;
                      widget.onChange(customizationModel);
                    }
                  },
                ),
        ),

        /// hiding last divider
        Divider(
            color: AppColors.kGray2.withOpacity(
                widget.customization.groupDetails.length == widget.index + 1
                    ? 0
                    : 0.1)),
      ],
    );
  }
}

class ItemQuentitySelector extends StatelessWidget {
  const ItemQuentitySelector({
    super.key,
    required this.itemQuentity,
    required this.enable,
    required this.onPressPlus,
    required this.onPressMinus,
  });

  final int itemQuentity;
  final bool enable;
  final VoidCallback onPressPlus;
  final VoidCallback onPressMinus;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment.centerRight,
      scale: 0.8,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 4,
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(enable ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(22)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 0,
                child: IconButton(
                    splashColor: AppColors.kMainBlue,
                    disabledColor: Colors.white.withOpacity(0.5),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: enable ? onPressMinus : null,
                    icon: const Icon(Icons.remove))),
            Expanded(
                flex: 1,
                child: CustomTextWidget(
                    text: "$itemQuentity",
                    fontSize: 16,
                    color: AppColors.kGray2.withOpacity(enable ? 1 : 0.5),
                    fontWeight: FontWeight.bold)),
            Expanded(
              flex: 0,
              child: IconButton(
                  splashColor: AppColors.kMainBlue,
                  disabledColor: Colors.white.withOpacity(0.5),
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: enable ? onPressPlus : null,
                  icon: const Icon(Icons.add)),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductInfoView extends StatelessWidget {
  const ProductInfoView({
    super.key,
    required this.prodcutInfoModel,
  });

  final ProductInfoModel prodcutInfoModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomTextWidget(
                  text: prodcutInfoModel.name,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          CustomTextWidget(
              text: ValidationService().formatPriceWithCurrency(
                  prodcutInfoModel.price.toDouble(), prodcutInfoModel.currency),
              fontSize: 18,
              color: AppColors.kGray2,
              fontWeight: FontWeight.bold),
          const SizedBox(height: 15),
          CustomTextWidget(
            text: prodcutInfoModel.description,
            fontSize: 12,
            textAlign: TextAlign.justify,
            color: AppColors.kGray2,
          ),
          const SizedBox(height: 10),
          RatingContainer(prodcutInfoModel: prodcutInfoModel),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class RatingContainer extends StatelessWidget {
  const RatingContainer({
    super.key,
    required this.prodcutInfoModel,
  });

  final ProductInfoModel prodcutInfoModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: AppColors.kGray2.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.thumb_up, color: AppColors.kBlue3, size: 14),
          const SizedBox(width: 6),
          CustomTextWidget(
              text: prodcutInfoModel.ratingPct ?? "0%",
              fontSize: 12,
              color: AppColors.kGray2,
              fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.prodcutInfoModel,
  });

  final ProductInfoModel prodcutInfoModel;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 2,
        child: Stack(children: [
          Hero(
            tag: prodcutInfoModel.productId,
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            prodcutInfoModel.photoUrl)))),
          ),
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
                  context.pop();
                },
              ),
            ),
          ),
        ]));
  }
}
