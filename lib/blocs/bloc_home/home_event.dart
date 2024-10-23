part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeFetchDataEvent extends HomeEvent {
  final Address address;
  final String department;

  const HomeFetchDataEvent({required this.address, required this.department});
  @override
  List<Object> get props => [address, department];
}

class HomeVendorFilterEvent extends HomeEvent {
  final List<FilterDataModel> selectedFilterOptionsList;
  const HomeVendorFilterEvent({required this.selectedFilterOptionsList});
  @override
  List<Object> get props => [selectedFilterOptionsList];
}

class HomeFilterByCategoryEvent extends HomeEvent {
  final String? categoryName;

  const HomeFilterByCategoryEvent({required this.categoryName});

  @override
  List<Object> get props => [categoryName ?? ''];
}
