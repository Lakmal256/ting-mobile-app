part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

class CartLoadedState extends CartState {
  final CartResModel? cartResModel;

  const CartLoadedState({required this.cartResModel});
  @override
  List<Object> get props => [cartResModel!];
}

class CartLoadingState extends CartState {}

class CartErrorState extends CartState {
  final String message;

  const CartErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class CartUpdatedState extends CartState {}
