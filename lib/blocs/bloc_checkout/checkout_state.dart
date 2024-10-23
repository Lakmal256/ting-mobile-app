part of 'checkout_bloc.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {}

class CheckoutLoadedState extends CheckoutState {
  final CheckoutModel model;

  const CheckoutLoadedState({required this.model});
  @override
  List<Object> get props => [model];
}

class CheckoutErrorState extends CheckoutState {
  final String error;

  const CheckoutErrorState({required this.error});
  @override
  List<Object> get props => [error];
}
