part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductFetchInialEvent extends ProductsEvent {
  @override
  List<Object> get props => [];
}

class ProductQuentityButtonEvent extends ProductsEvent {
  final Quantity value;

  const ProductQuentityButtonEvent({required this.value});
  @override
  List<Object> get props => [value];
}

class ProductStoreStateEvent extends ProductsEvent {
  final ProductInfoModel prodcutInfoModel;

  const ProductStoreStateEvent({required this.prodcutInfoModel});
  @override
  List<Object> get props => [prodcutInfoModel];
}

class ProductAddCustomizationEvent extends ProductsEvent {
  final CustomizationModel customizationModel;

  const ProductAddCustomizationEvent({required this.customizationModel});
  @override
  List<Object> get props => [customizationModel];
}

class ProductAddtoCartPressEvent extends ProductsEvent {
  final String customerId;
  final String instructions;
  final CartResModel? cartResDataModel;

  const ProductAddtoCartPressEvent(
      {required this.customerId,
      required this.instructions,
      required this.cartResDataModel});
  @override
  List<Object> get props => [customerId, instructions];
}
