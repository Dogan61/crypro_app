import 'package:equatable/equatable.dart';

class SymbolEntity extends Equatable {
  const SymbolEntity({
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.status,
  });
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final String status;

  @override
  List<Object?> get props => [symbol, baseAsset, quoteAsset, status];
}
