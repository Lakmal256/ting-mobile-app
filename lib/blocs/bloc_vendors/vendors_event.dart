part of 'vendors_bloc.dart';

sealed class VendorsEvent extends Equatable {
  const VendorsEvent();

  @override
  List<Object> get props => [];
}

class VendorItemTapEvent extends VendorsEvent {
  final VendorsModel vendor;

  const VendorItemTapEvent({required this.vendor});
  @override
  List<Object> get props => [vendor];
}

class VendorGetMenusEvent extends VendorsEvent {
  @override
  List<Object> get props => [];
}

class VendorProductOnTapEvent extends VendorsEvent {
  final String productId;

  const VendorProductOnTapEvent({required this.productId});
  @override
  List<Object> get props => [productId];
}
