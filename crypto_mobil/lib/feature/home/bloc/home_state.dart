part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.prices = const [],
    this.tickers = const [],
    this.errorMessage,
    this.isRefreshing = false,
  });
  final HomeStatus status;
  final List<PriceEntity> prices;
  final List<Ticker24hEntity> tickers;
  final String? errorMessage;
  final bool isRefreshing;

  HomeState copyWith({
    HomeStatus? status,
    List<PriceEntity>? prices,
    List<Ticker24hEntity>? tickers,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return HomeState(
      status: status ?? this.status,
      prices: prices ?? this.prices,
      tickers: tickers ?? this.tickers,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    prices,
    tickers,
    errorMessage,
    isRefreshing,
  ];
}
