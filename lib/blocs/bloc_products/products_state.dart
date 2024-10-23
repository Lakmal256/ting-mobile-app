part of 'products_bloc.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class ProductQuntityState extends ProductsState {
  final int value;

  const ProductQuntityState({required this.value});
  @override
  List<Object> get props => [value];
}

class ProductsInitialFetchLoadingState extends ProductsState {}

class ProductCustomizationResponseState extends ProductsState {}

class ProductPriceState extends ProductsState {
  final double price;

  const ProductPriceState({required this.price});
  @override
  List<Object> get props => [price];
}

class ProductEasyLoadingState extends ProductsState {}

class ProductAddtoCartLoadingState extends ProductsState {}

class ProductAddtoCartFinishState extends ProductsState {}

class ProductErrorState extends ProductsState {
  final String message;

  const ProductErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
