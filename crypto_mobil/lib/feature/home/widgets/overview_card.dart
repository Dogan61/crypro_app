import 'package:crypto_mobil/core/constants/text_const.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({required this.tickers, super.key});

  final List<Ticker24hEntity> tickers;

  @override
  Widget build(BuildContext context) {
    final totalQuoteVolume = tickers.fold<double>(
      0,
      (sum, t) => sum + t.quoteVolume,
    );

    late final Ticker24hEntity btcTicker;
    if (tickers.isEmpty) {
      btcTicker = _emptyTicker;
    } else {
      final btcMatches = tickers.where(
        (t) => t.symbol.toUpperCase() == 'BTCUSDT',
      );
      btcTicker = btcMatches.isNotEmpty ? btcMatches.first : tickers.first;
    }

    final btcDominance = totalQuoteVolume == 0
        ? 0.0
        : (btcTicker.quoteVolume / totalQuoteVolume).clamp(0.0, 1.0);

    final btcDominancePercent = (btcDominance * 100).toStringAsFixed(1);
    final totalVolumeText = _formatLargeNumber(totalQuoteVolume);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TextConst.globalMarketCap,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
              Text(
                TextConst.volume24h,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // Burada gerçek global market cap yok, bu nedenle
                // kullanıcıya daha çok "overview" hissi vermek için
                // BTC fiyatını gösteriyoruz.
                '\$${btcTicker.lastPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                totalVolumeText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TextConst.btcDominance,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
              Text(
                '$btcDominancePercent%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: btcDominance,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.yellowAccent.withOpacity(0.8),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLargeNumber(double value) {
    if (value >= 1e12) {
      return '${(value / 1e12).toStringAsFixed(2)}T';
    }
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)}B';
    }
    if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}M';
    }
    if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)}K';
    }
    return value.toStringAsFixed(2);
  }
}

// tickers listesi boşken fallback için kullanılan dummy ticker
const Ticker24hEntity _emptyTicker = Ticker24hEntity(
  symbol: 'BTCUSDT',
  priceChange: 0,
  priceChangePercent: 0,
  weightedAvgPrice: 0,
  prevClosePrice: 0,
  lastPrice: 0,
  lastQty: 0,
  bidPrice: 0,
  askPrice: 0,
  openPrice: 0,
  highPrice: 0,
  lowPrice: 0,
  volume: 0,
  quoteVolume: 0,
  openTime: 0,
  closeTime: 0,
  firstId: 0,
  lastId: 0,
  count: 0,
);
