part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartFetchDataEvent extends CartEvent {
  final String customerId;

  const CartFetchDataEvent({required this.customerId});
  @override
  List<Object> get props => [customerId];
}

class CartUpdateEvent extends CartEvent {
  final String customerId;
  final Item updatedItem;

  const CartUpdateEvent(
      {required this.customerId,
      required this.updatedItem});
  @override
  List<Object> get props => [updatedItem];
}

class CartDeleteItemEvent extends CartEvent {
  final Item item;
  final String customerId;
  const CartDeleteItemEvent({required this.item, required this.customerId});
  @override
  List<Object> get props => [item, customerId];
}
