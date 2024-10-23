part of 'vendors_bloc.dart';

sealed class VendorsState extends Equatable {
  const VendorsState();

  @override
  List<Object> get props => [];
}

final class VendorsInitial extends VendorsState {}

final class VendorsListState extends VendorsState {
  final List<VendorsModel> list;

  const VendorsListState({required this.list});
  @override
  List<Object> get props => [list];
}

final class VendorsFilterListState extends VendorsState {
  final List<VendorsModel> list;

  const VendorsFilterListState({required this.list});
  @override
  List<Object> get props => [list];
}

final class VendorsListLoadingState extends VendorsState {
  @override
  List<Object> get props => [];
}

final class PageLoadingState extends VendorsState {}

final class SearchTextErrorState extends VendorsState {}

final class SearchSuccessState extends VendorsState {
  const SearchSuccessState();
  @override
  List<Object> get props => [];
}

final class ListSearchSuccessState extends VendorsState {
  const ListSearchSuccessState();
  @override
  List<Object> get props => [];
}

class ShowSearchButtonState extends VendorsState {
  final bool value;

  const ShowSearchButtonState({required this.value});
  @override
  List<Object> get props => [value];
}

class VendorItemTapState extends VendorsState {
  final String id;

  const VendorItemTapState({required this.id});
  @override
  List<Object> get props => [id];
}

class SearchListLoadingState extends VendorsState {}

class VendorGetMenuSuccessState extends VendorsState {
  final VendorsMenuModel menuModel;
  final VendorProfileModel profileModel;

  const VendorGetMenuSuccessState(
      {required this.menuModel, required this.profileModel});
  @override
  List<Object> get props => [menuModel, profileModel];
}

class ShopProductLoadingState extends VendorsState {}

class ShopFilterdProductState extends VendorsState {
  final List<ProductItem> list;

  const ShopFilterdProductState({required this.list});
  @override
  List<Object> get props => [list];
}

class ShopSearchTextErrorState extends VendorsState {}

class VendorLoadingState extends VendorsState {}

class VendorErrorState extends VendorsState {
  final String error;

  const VendorErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class VendorPorductViewState extends VendorsState {
  final ProductInfoModel prodcutInfoModel;
  const VendorPorductViewState({required this.prodcutInfoModel});
  @override
  List<Object> get props => [prodcutInfoModel];
}
