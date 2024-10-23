part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class FetchCategorySearchEvent extends SearchEvent {}

class SearchViewUpdateEvenet extends SearchEvent {
  final SearchView view;
  const SearchViewUpdateEvenet({required this.view});

  @override
  List<Object> get props => [view];
}

class SearchProductEvent extends SearchEvent {
  final String keyword;
  final Address address;

  const SearchProductEvent({required this.keyword, required this.address});
  @override
  List<Object> get props => [keyword, address];
}
