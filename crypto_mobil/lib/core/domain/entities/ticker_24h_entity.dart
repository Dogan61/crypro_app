import 'package:equatable/equatable.dart';

class Ticker24hEntity extends Equatable {
  const Ticker24hEntity({
    required this.symbol,
    required this.priceChange,
    required this.priceChangePercent,
    required this.weightedAvgPrice,
    required this.prevClosePrice,
    required this.lastPrice,
    required this.lastQty,
    required this.bidPrice,
    required this.askPrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.quoteVolume,
    required this.openTime,
    required this.closeTime,
    required this.firstId,
    required this.lastId,
    required this.count,
  });
  final String symbol;
  final double priceChange;
  final double priceChangePercent;
  final double weightedAvgPrice;
  final double prevClosePrice;
  final double lastPrice;
  final double lastQty;
  final double bidPrice;
  final double askPrice;
  final double openPrice;
  final double highPrice;
  final double lowPrice;
  final double volume;
  final double quoteVolume;
  final int openTime;
  final int closeTime;
  final int firstId;
  final int lastId;
  final int count;

  @override
  List<Object?> get props => [
    symbol,
    priceChange,
    priceChangePercent,
    weightedAvgPrice,
    prevClosePrice,
    lastPrice,
    lastQty,
    bidPrice,
    askPrice,
    openPrice,
    highPrice,
    lowPrice,
    volume,
    quoteVolume,
    openTime,
    closeTime,
    firstId,
    lastId,
    count,
  ];
}
