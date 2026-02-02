part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchSymbols extends SearchEvent {
  const SearchSymbols(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}
