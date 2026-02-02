import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:flutter/material.dart';

class CoinDetailTitle extends StatelessWidget {
  const CoinDetailTitle({required this.symbol, required this.price, super.key});
  final String symbol;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          '\$${_formatPrice(price)}',
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Text(symbol, style: context.theme.textTheme.bodyMedium),
      ],
    );
  }

  String _formatPrice(String price) {
    final priceDouble = double.tryParse(price) ?? 0.0;

    if (priceDouble < 0.01) {
      return priceDouble
          .toStringAsFixed(6)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }

    if (priceDouble < 1) {
      return priceDouble
          .toStringAsFixed(4)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }

    return priceDouble.toStringAsFixed(2);
  }
}
