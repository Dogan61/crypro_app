part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarketData extends HomeEvent {
  const LoadMarketData();
}

class RefreshMarketData extends HomeEvent {
  const RefreshMarketData();
}

class SubscribeToRealtimePrices extends HomeEvent {
  const SubscribeToRealtimePrices(this.symbols);
  final List<String> symbols;

  @override
  List<Object?> get props => [symbols];
}

class UnsubscribeFromRealtimePrices extends HomeEvent {
  const UnsubscribeFromRealtimePrices(this.symbols);
  final List<String> symbols;

  @override
  List<Object?> get props => [symbols];
}

class UpdateRealtimePrice extends HomeEvent {
  const UpdateRealtimePrice(this.price);
  final PriceEntity price;

  @override
  List<Object?> get props => [price];
}
