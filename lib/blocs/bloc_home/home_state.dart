part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeBlocInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeDataFetchSuccess extends HomeState {
  final List<ShopTypeModel> shopTypeList;
  final List<CategoriesModel> categoriesList;
  final List<VendorsModel> vendorsList;
  final List<BannersModel> bannersList;

  const HomeDataFetchSuccess({
    required this.shopTypeList,
    required this.categoriesList,
    required this.vendorsList,
    required this.bannersList,
  });
}

class HomeDateErrorState extends HomeState {
  final String errorMessage;

  const HomeDateErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class HomeDataFilterdState extends HomeState {
  final List<VendorsModel> filteredVendorsList;

  const HomeDataFilterdState({
    required this.filteredVendorsList,
  });

  @override
  List<Object> get props => [filteredVendorsList];
}

class HomeDataFilterCleanState extends HomeState {
  final List<VendorsModel> filteredVendorsList;
  const HomeDataFilterCleanState({required this.filteredVendorsList});

  @override
  List<Object> get props => [filteredVendorsList];
}
