import 'package:crypto_mobil/core/domain/entities/symbol_entity.dart';
import 'package:crypto_mobil/core/domain/usecases/get_symbols_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._getSymbolsUseCase) : super(const SearchState()) {
    on<SearchSymbols>(_onSearchSymbols);
    on<ClearSearch>(_onClearSearch);
  }
  final GetSymbolsUseCase _getSymbolsUseCase;

  Future<void> _onSearchSymbols(
    SearchSymbols event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading, query: event.query));

    final result = await _getSymbolsUseCase(search: event.query, limit: 50);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (symbols) =>
          emit(state.copyWith(status: SearchStatus.success, symbols: symbols)),
    );
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(const SearchState());
  }
}
