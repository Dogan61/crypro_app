part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.symbols = const [],
    this.errorMessage,
  });
  final SearchStatus status;
  final String query;
  final List<SymbolEntity> symbols;
  final String? errorMessage;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<SymbolEntity>? symbols,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      symbols: symbols ?? this.symbols,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, query, symbols, errorMessage];
}
