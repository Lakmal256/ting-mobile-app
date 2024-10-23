// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:app/data/data.dart';
import 'package:flutter_animate/flutter_animate.dart';

part 'products_event.dart';
part 'products_state.dart';

enum Quantity { plus, minus }

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final MarketplaceRepository _marketplaceRepository = MarketplaceRepository();
  int quantity = 1;

  double _totalPrice = 0;
  get totalPrice => _totalPrice;

  late Product selectedProduct;
  ProductInfoModel? productInfo;
  List<CustomizationModel> customizationsList = [];

  ProductsBloc() : super(ProductsInitial()) {
    on<ProductQuentityButtonEvent>(_productQuentityButtonEvent);
    on<ProductStoreStateEvent>(_productStoreStateEvent);
    on<ProductAddCustomizationEvent>(_productAddCustomizationEvent);
    on<ProductAddtoCartPressEvent>(_productAddtoCartPressEvent);
  }

  FutureOr<void> _productQuentityButtonEvent(
      ProductQuentityButtonEvent event, Emitter<ProductsState> emit) {
    if (event.value == Quantity.plus) {
      quantity++;
    } else {
      quantity == 1 ? 1 : quantity--;
    }

    emit(ProductQuntityState(value: quantity));
  }

  FutureOr<void> _productStoreStateEvent(
      ProductStoreStateEvent event, Emitter<ProductsState> emit) {
    customizationsList.clear();

    productInfo = event.prodcutInfoModel;
    _totalPrice = event.prodcutInfoModel.price.toDouble();
  }

  FutureOr<void> _productAddCustomizationEvent(
      ProductAddCustomizationEvent event, Emitter<ProductsState> emit) {
    final containIndex = customizationsList.indexWhere((item) =>
        item.groupDetails.productId ==
        event.customizationModel.groupDetails.productId);

    // Checking if the customization is a multi-quantity type and quantity is zero
    if (event.customizationModel.groupDetails.multiQuanty &&
        event.customizationModel.quantity == 0) {
      // If quantity is zero, remove the item
      _removeItem(containIndex);
    } else if (event.customizationModel.groupDetails.multiQuanty &&
        event.customizationModel.quantity >= 1) {
      // If quantity is more than or equal to 1 and it's a multi-quantity type
      if (containIndex == -1) {
        // If item doesn't exist in the list, add it
        _addItem(event.customizationModel);
      } else {
        // If item exists, remove it first and then add the updated one
        _removeItem(containIndex);
        _addItem(event.customizationModel);
      }
    } else {
      // For single quantity customizations
      if (containIndex == -1) {
        // If item doesn't exist in the list, add it
        _addItem(event.customizationModel);
      } else {
        // If item exists, remove it
        _removeItem(containIndex);
      }
    }

    emit(ProductPriceState(price: _totalPrice));
  }

  void _addItem(CustomizationModel customizationModel) {
    customizationsList.add(customizationModel);
    // Recalculate the total price after adding the item
    _calculateTotalPrice();
  }

  void _removeItem(int index) {
    customizationsList.removeAt(index);
    // Recalculate the total price after removing the item
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    _totalPrice = productInfo!.price.toDouble();
    for (var customization in customizationsList) {
      if (customization.groupDetails.multiQuanty) {
        // If it's a multi-quantity customization, multiply the price with quantity
        _totalPrice +=
            customization.groupDetails.price * customization.quantity;
      } else {
        // If it's a single quantity customization, add its price directly
        _totalPrice += customization.groupDetails.price;
      }
    }
    log("Total Price Updated = $_totalPrice ");
  }

  FutureOr<void> _productAddtoCartPressEvent(
      ProductAddtoCartPressEvent event, Emitter<ProductsState> emit) async {
    // Emit loading state to indicate the process has started
    emit(ProductAddtoCartLoadingState());

    // Finding customizations with minimum selection requirement greater than zero
    var mandatoryCustomizations =
        productInfo!.customizations.where((item) => item.minSelectItems > 0);

    // Checking if all mandatory selections have been made
    bool allMandatorySelected = mandatoryCustomizations.every((customization) {
      // Check if the customization is present in the customizationsList
      return customizationsList.any((selectedCustomization) =>
          selectedCustomization.groupId == customization.groupId);
    });

    if (!allMandatorySelected) {
      // Mandatory selections are missing, emit an error state and return from the function
      emit(const ProductErrorState(
          message: "Please complete all mandatory selections."));
      return;
    }

    // Add the product to the cart
    List<ProductConfig> configsList = [];
    if (customizationsList.isNotEmpty) {
      for (var customization in customizationsList) {
        configsList.add(ProductConfig(
            configId: customization.groupDetails.id,
            configPrice: customization.groupDetails.price,
            quantity: customization.quantity));
      }
    }

    // Prepare items to add to the cart
    List<ItemElement> items = [];
    if (event.cartResDataModel == null ||
        event.cartResDataModel!.items.isEmpty) {
      // If cart is empty, directly add the product
      items.add(ItemElement(
          item: ItemItem(
              productId: productInfo!.productId, productConfigs: configsList),
          shopId: productInfo!.shopId,
          quantity: quantity,
          price: totalPrice,
          instructions: event.instructions));
    } else {
      // If cart is not empty, add existing items along with the new product
      for (var item in event.cartResDataModel!.items) {
        List<ProductConfig> productConfig = [];

        for (var config in item.customizations) {
          productConfig.add(ProductConfig(
              configId: config.configId,
              configPrice: config.price,
              quantity: config.qty));
        }

        items.add(ItemElement(
            item: ItemItem(
                productId: item.productId, productConfigs: productConfig),
            shopId: item.shopId,
            quantity: item.qty,
            price: item.price.toDouble(),
            instructions: item.instructions));
      }
      items.add(ItemElement(
          item: ItemItem(
              productId: productInfo!.productId, productConfigs: configsList),
          shopId: productInfo!.shopId,
          quantity: quantity,
          price: productInfo!.price.toDouble(),
          instructions: event.instructions));
    }

    // Prepare cart data
    var cart = CartDataModel(
        customerId: event.customerId, instructions: '', items: items);

    try {
      var jsonCart = cart.toJson();

      // Update cart if it already exists, otherwise initialize a new cart
      if (event.cartResDataModel != null) {
        log("Cart Update");
        _marketplaceRepository.updateCart(
            cartId: event.cartResDataModel!.id, updatedCart: jsonCart);
      } else {
        log("Cart Init");
        _marketplaceRepository.cartInit(cartData: jsonCart);
      }
    } on DioException {
      // Handle Dio exception
      emit(const ProductErrorState(message: "Add to cart failed!"));
    } catch (e) {
      // Handle other exceptions
      emit(const ProductErrorState(message: "Add to cart failed!"));
    }

    // Simulate delay before completing the process
    await Future.delayed(2.seconds)
        .whenComplete(() => emit(ProductAddtoCartFinishState()));
  }
}
