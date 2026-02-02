import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/domain/usecases/get_prices_usecase.dart';
import 'package:crypto_mobil/core/domain/usecases/get_ticker_24h_usecase.dart';
import 'package:crypto_mobil/core/domain/usecases/get_watchlist_usecase.dart';
import 'package:crypto_mobil/core/domain/usecases/toggle_watchlist_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

@injectable
class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc(
    this._getWatchlistUseCase,
    this._toggleWatchlistUseCase,
    this._getPricesUseCase,
    this._getTicker24hUseCase,
  ) : super(const WatchlistState()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  final GetWatchlistUseCase _getWatchlistUseCase;
  final ToggleWatchlistUseCase _toggleWatchlistUseCase;
  final GetPricesUseCase _getPricesUseCase;
  final GetTicker24hUseCase _getTicker24hUseCase;

  Future<void> _onLoadWatchlist(
    LoadWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(state.copyWith(status: WatchlistStatus.loading));

    final watchlistResult = await _getWatchlistUseCase();

    await watchlistResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: WatchlistStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (symbols) async {
        if (symbols.isEmpty) {
          emit(
            state.copyWith(
              status: WatchlistStatus.success,
              symbols: const [],
              prices: const [],
              tickers: const [],
            ),
          );
          return;
        }

        final pricesResult = await _getPricesUseCase();
        final tickersResult = await _getTicker24hUseCase(symbols: symbols);

        pricesResult.fold(
          (failure) => emit(
            state.copyWith(
              status: WatchlistStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (prices) {
            tickersResult.fold(
              (failure) => emit(
                state.copyWith(
                  status: WatchlistStatus.success,
                  symbols: symbols,
                  prices: prices
                      .where((p) => symbols.contains(p.symbol))
                      .toList(),
                  tickers: const [],
                  errorMessage: failure.message,
                ),
              ),
              (tickers) => emit(
                state.copyWith(
                  status: WatchlistStatus.success,
                  symbols: symbols,
                  prices: prices
                      .where((p) => symbols.contains(p.symbol))
                      .toList(),
                  tickers: tickers,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<WatchlistState> emit,
  ) async {
    final isFavorite = state.symbols.contains(event.symbol);

    final result = await _toggleWatchlistUseCase(
      symbol: event.symbol,
      isCurrentlyFavorite: isFavorite,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WatchlistStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (symbols) => add(const LoadWatchlist()),
    );
  }
}
