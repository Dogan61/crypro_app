import 'package:equatable/equatable.dart';

class PriceEntity extends Equatable {
  const PriceEntity({required this.symbol, required this.price});
  final String symbol;
  final String price;

  /// Formatted price without unnecessary trailing zeros
  String get formattedPrice {
    final priceDouble = double.tryParse(price) ?? 0.0;
    
    // If price is very small (< 0.01), show 6 decimals
    if (priceDouble < 0.01) {
      return priceDouble.toStringAsFixed(6)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
    
    // If price is small (< 1), show 4 decimals
    if (priceDouble < 1) {
      return priceDouble.toStringAsFixed(4)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
    
    // Otherwise show 2 decimals
    return priceDouble.toStringAsFixed(2);
  }

  @override
  List<Object?> get props => [symbol, price];
}
