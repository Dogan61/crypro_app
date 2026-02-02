part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();
}

class ToggleFavorite extends WatchlistEvent {
  const ToggleFavorite(this.symbol);

  final String symbol;

  @override
  List<Object?> get props => [symbol];
}

