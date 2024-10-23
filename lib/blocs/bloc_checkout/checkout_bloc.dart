import 'dart:async';
import 'dart:developer';

import 'package:app/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final MarketplaceRepository _marketplaceRepository = MarketplaceRepository();
  late CheckoutModel checkoutModel;
  CheckoutBloc() : super(CheckoutInitial()) {
    on<FetchCheckoutDataEvent>(_fetchCheckoutDataEvent);
  }

  FutureOr<void> _fetchCheckoutDataEvent(
      FetchCheckoutDataEvent event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoadingState());

    try {
      checkoutModel = await _marketplaceRepository.getCheckout(
          cartId: event.cartId,
          customerId: event.customerID,
          lat: event.lat,
          lon: event.lon);

      emit(CheckoutLoadedState(model: checkoutModel));
    } catch (e) {
      log("Checkout Error $e");
      emit(const CheckoutErrorState(error: "Something went wrong!"));
    }
  }
}
