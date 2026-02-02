part of 'watchlist_bloc.dart';

enum WatchlistStatus { initial, loading, success, failure }

class WatchlistState extends Equatable {
  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.symbols = const [],
    this.prices = const [],
    this.tickers = const [],
    this.errorMessage,
  });

  final WatchlistStatus status;
  final List<String> symbols;
  final List<PriceEntity> prices;
  final List<Ticker24hEntity> tickers;
  final String? errorMessage;

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<String>? symbols,
    List<PriceEntity>? prices,
    List<Ticker24hEntity>? tickers,
    String? errorMessage,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      symbols: symbols ?? this.symbols,
      prices: prices ?? this.prices,
      tickers: tickers ?? this.tickers,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, symbols, prices, tickers, errorMessage];
}
