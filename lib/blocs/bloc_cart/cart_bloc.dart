// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:app/blocs/blocs_exports.dart';
import 'package:app/data/data.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final _marketplaceRepo = MarketplaceRepository();
  CartResModel? cartResDataModel;
  CartBloc() : super(CartInitial()) {
    on<CartFetchDataEvent>(_cartInizialEvent);
    on<CartUpdateEvent>(_cartUpdateEvent);
    on<CartDeleteItemEvent>(_cartDeleteItemEvent);
  }

  FutureOr<void> _cartInizialEvent(
      CartFetchDataEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());

    try {
      cartResDataModel =
          await _marketplaceRepo.getActiveCart(customerId: event.customerId);
    } on DioException catch (e) {
      cartResDataModel = null;
      if (e is RequestFailureException) {
        emit(const CartErrorState(message: "Request failed!"));
      }
      if (e is ResponseTimoutException) {
        emit(const CartErrorState(message: "Request time-out!"));
      }
      emit(const CartErrorState(message: "Somthing went wrong!"));
    } catch (e) {
      log("Cart Error $e");
      cartResDataModel = null;
    }

    emit(CartLoadedState(cartResModel: cartResDataModel!));
  }

  FutureOr<void> _cartUpdateEvent(
      CartUpdateEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());

    var index = cartResDataModel!.items
        .indexWhere((item) => item.lineId == event.updatedItem.lineId);

    cartResDataModel!.items[index] = event.updatedItem;
    log("Updated Item : ${cartResDataModel!.items[index].qty}");
    // Update Cart

    List<ItemElement> items = [];

    for (var item in cartResDataModel!.items) {
      List<ProductConfig> configsList = [];
      if (item.customizations.isNotEmpty) {
        for (var customization in item.customizations) {
          configsList.add(ProductConfig(
              configId: customization.configId,
              configPrice: customization.price,
              quantity: customization.qty));
        }
      }

      items.add(ItemElement(
          item:
              ItemItem(productId: item.productId, productConfigs: configsList),
          shopId: item.shopId,
          quantity: item.qty,
          price: item.price.toDouble(),
          instructions: item.instructions));
    }

    CartDataModel cart = CartDataModel(
        customerId: event.customerId, instructions: '', items: items);

    await _marketplaceRepo.updateCart(
      cartId: cartResDataModel!.id,
      updatedCart: cart.toJson(),
    );

    emit(CartUpdatedState());
  }

  FutureOr<void> _cartDeleteItemEvent(
      CartDeleteItemEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());

    var index = cartResDataModel!.items
        .indexWhere((item) => item.lineId == event.item.lineId);

    cartResDataModel!.items.removeAt(index);

    log("${cartResDataModel!.toJson()}");

    List<ItemElement> items = [];

    for (var item in cartResDataModel!.items) {
      List<ProductConfig> configsList = [];
      if (item.customizations.isNotEmpty) {
        for (var customization in item.customizations) {
          configsList.add(ProductConfig(
              configId: customization.configId,
              configPrice: customization.price,
              quantity: customization.qty));
        }
      }

      items.add(ItemElement(
          item:
              ItemItem(productId: item.productId, productConfigs: configsList),
          shopId: item.shopId,
          quantity: item.qty,
          price: item.price.toDouble() * item.qty,
          instructions: item.instructions));
    }

    CartDataModel cart = CartDataModel(
        customerId: event.customerId, instructions: '', items: items);

    log("Cart ${cart.toJson()} ");

    await _marketplaceRepo.updateCart(
      cartId: cartResDataModel!.id,
      updatedCart: cart.toJson(),
    );

    emit(CartUpdatedState());
  }
}
