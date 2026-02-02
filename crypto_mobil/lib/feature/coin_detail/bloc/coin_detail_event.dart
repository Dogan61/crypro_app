part of 'coin_detail_bloc.dart';

abstract class CoinDetailEvent extends Equatable {
  const CoinDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoinDetail extends CoinDetailEvent {
  const LoadCoinDetail(this.symbol);
  final String symbol;

  @override
  List<Object?> get props => [symbol];
}

class ChangeTimeInterval extends CoinDetailEvent {
  const ChangeTimeInterval(this.interval);
  final String interval;

  @override
  List<Object?> get props => [interval];
}

class SubscribeToCoinPrice extends CoinDetailEvent {
  const SubscribeToCoinPrice(this.symbol);
  final String symbol;

  @override
  List<Object?> get props => [symbol];
}

class UpdateCoinPrice extends CoinDetailEvent {
  const UpdateCoinPrice(this.price);
  final PriceEntity price;

  @override
  List<Object?> get props => [price];
}
