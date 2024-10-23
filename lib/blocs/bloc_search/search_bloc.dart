import 'dart:async';

import 'package:app/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

enum SearchView { defultView, recentView, resultView }

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final marketplaceRepository = MarketplaceRepository();

  SearchBloc() : super(SearchInitial()) {
    on<FetchCategorySearchEvent>(_fetchCategorySearchEvent);
    on<SearchViewUpdateEvenet>(_seachViewUpdateEvenet);
    on<SearchProductEvent>(_searchProductEvent);
  }

  FutureOr<void> _fetchCategorySearchEvent(
      FetchCategorySearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchViewLoadingState());

    List<CategoriesModel> categoriesList =
        await marketplaceRepository.getCategories(department: "Restaurants");

    emit(SearchViewCategorySuccessState(categoriesList: categoriesList));
  }

  FutureOr<void> _seachViewUpdateEvenet(
      SearchViewUpdateEvenet event, Emitter<SearchState> emit) {
    emit(SearchViewUpdateState(view: event.view));
  }

  FutureOr<void> _searchProductEvent(
      SearchProductEvent event, Emitter<SearchState> emit) async {
    emit(SearchViewLoadingState());

    final List<VendorsModel> model =
        await marketplaceRepository.searchProductsByVendor(
            address: event.address, searchText: event.keyword);
    emit(SearchProductsSuccessState(model: model));
    emit(const SearchViewUpdateState(view: SearchView.resultView));
  }
}
