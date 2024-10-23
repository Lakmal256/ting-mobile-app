part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

class SearchViewLoadingState extends SearchState {}

class SearchViewCategorySuccessState extends SearchState {
  final List<CategoriesModel> categoriesList;

  const SearchViewCategorySuccessState({required this.categoriesList});
  @override
  List<Object> get props => [categoriesList];
}

class SearchViewUpdateState extends SearchState {
  final SearchView view;

  const SearchViewUpdateState({required this.view});
  @override
  List<Object> get props => [view];
}

class SearchProductsSuccessState extends SearchState {
  final List<VendorsModel> model;

  const SearchProductsSuccessState({required this.model});
  @override
  List<Object> get props => [model];
}
