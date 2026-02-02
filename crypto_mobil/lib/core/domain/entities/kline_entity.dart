import 'package:equatable/equatable.dart';

class KlineEntity extends Equatable {
  const KlineEntity({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.closeTime,
    required this.quoteVolume,
    required this.trades,
  });
  final int openTime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final int closeTime;
  final double quoteVolume;
  final int trades;

  @override
  List<Object?> get props => [
    openTime,
    open,
    high,
    low,
    close,
    volume,
    closeTime,
    quoteVolume,
    trades,
  ];
}
