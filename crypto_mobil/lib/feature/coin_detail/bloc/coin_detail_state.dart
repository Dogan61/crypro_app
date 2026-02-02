part of 'coin_detail_bloc.dart';

enum CoinDetailStatus { initial, loading, success, failure }

class CoinDetailState extends Equatable {
  const CoinDetailState({
    this.status = CoinDetailStatus.initial,
    this.symbol = '',
    this.currentPrice,
    this.klines = const [],
    this.ticker,
    this.selectedInterval = '1h',
    this.errorMessage,
  });
  final CoinDetailStatus status;
  final String symbol;
  final PriceEntity? currentPrice;
  final List<KlineEntity> klines;
  final Ticker24hEntity? ticker;
  final String selectedInterval;
  final String? errorMessage;

  CoinDetailState copyWith({
    CoinDetailStatus? status,
    String? symbol,
    PriceEntity? currentPrice,
    List<KlineEntity>? klines,
    Ticker24hEntity? ticker,
    String? selectedInterval,
    String? errorMessage,
  }) {
    return CoinDetailState(
      status: status ?? this.status,
      symbol: symbol ?? this.symbol,
      currentPrice: currentPrice ?? this.currentPrice,
      klines: klines ?? this.klines,
      ticker: ticker ?? this.ticker,
      selectedInterval: selectedInterval ?? this.selectedInterval,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    symbol,
    currentPrice,
    klines,
    ticker,
    selectedInterval,
    errorMessage,
  ];
}
