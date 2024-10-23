part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class FetchCheckoutDataEvent extends CheckoutEvent {
  final String cartId;
  final String customerID;
  final String lat;
  final String lon;

  const FetchCheckoutDataEvent(
      {required this.cartId,
      required this.customerID,
      required this.lat,
      required this.lon});
  @override
  List<Object> get props => [cartId, customerID];
}
