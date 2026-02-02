import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/feature/coin_detail/widgets/market_cap_card.dart';
import 'package:flutter/material.dart';

class MarketStatsGrid extends StatelessWidget {
  const MarketStatsGrid({required this.ticker, super.key});
  final Ticker24hEntity ticker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: [
          MarketCapCard(
            title: '24h High',
            value: '\$${_formatPrice(ticker.highPrice)}',
          ),
          MarketCapCard(
            title: '24h Low',
            value: '\$${_formatPrice(ticker.lowPrice)}',
          ),
          MarketCapCard(
            title: '24h Volume',
            value:
                '${_formatVolume(ticker.volume)} ${ticker.symbol.replaceAll('USDT', '')}',
          ),
          MarketCapCard(
            title: 'Quote Volume',
            value: '\$${_formatLargeNumber(ticker.quoteVolume)}',
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price < 0.01) {
      return price
          .toStringAsFixed(6)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
    if (price < 1) {
      return price
          .toStringAsFixed(4)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
    return price.toStringAsFixed(2);
  }

  String _formatVolume(double volume) {
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(2)}M';
    }
    if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(2)}K';
    }
    return volume.toStringAsFixed(2);
  }

  String _formatLargeNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    }
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }
}
