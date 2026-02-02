import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/feature/home/widgets/home_view_filter.dart';
import 'package:flutter/material.dart';

mixin MarketFilterMixin<T extends StatefulWidget> on State<T> {
  MarketFilter selectedFilter = MarketFilter.all;

  void updateFilter(MarketFilter filter) {
    if (!mounted) return;
    setState(() => selectedFilter = filter);
  }

  List<PriceEntity> applyFilter({
    required List<PriceEntity> prices,
    required List<Ticker24hEntity> tickers,
  }) {
    final mutablePrices = List<PriceEntity>.from(prices);

    switch (selectedFilter) {
      case MarketFilter.all:
        return mutablePrices;

      case MarketFilter.gainers:
        return mutablePrices.where((p) {
          final ticker = tickers
              .where((t) => t.symbol == p.symbol)
              .cast<Ticker24hEntity?>()
              .firstOrNull;
          return (ticker?.priceChangePercent ?? 0) > 0;
        }).toList()..sort((a, b) {
          final ta = tickers
              .where((t) => t.symbol == a.symbol)
              .cast<Ticker24hEntity?>()
              .firstOrNull;
          final tb = tickers
              .where((t) => t.symbol == b.symbol)
              .cast<Ticker24hEntity?>()
              .firstOrNull;
          return (tb?.priceChangePercent ?? 0).compareTo(
            ta?.priceChangePercent ?? 0,
          );
        });

      case MarketFilter.losers:
        return mutablePrices.where((p) {
          final ticker = tickers
              .where((t) => t.symbol == p.symbol)
              .cast<Ticker24hEntity?>()
              .firstOrNull;
          return (ticker?.priceChangePercent ?? 0) < 0;
        }).toList()..sort((a, b) {
          final ta = tickers
              .where((t) => t.symbol == a.symbol)
              .cast<Ticker24hEntity?>()
              .firstOrNull;
          final tb = tickers
              .where((t) => t.symbol == b.symbol)
              .cast<Ticker24hEntity?>()
              .firstOrNull;
          return (ta?.priceChangePercent ?? 0).compareTo(
            tb?.priceChangePercent ?? 0,
          );
        });

      case MarketFilter.watchlist:
        return mutablePrices;
    }
  }
}
