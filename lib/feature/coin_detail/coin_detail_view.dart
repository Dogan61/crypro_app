import 'package:crypto_app/feature/coin_detail/widgets/coin_detail_bottom_nav.dart';
import 'package:crypto_app/feature/coin_detail/widgets/coin_detail_custom_appbar.dart';
import 'package:crypto_app/feature/coin_detail/widgets/coin_detail_graph.dart';
import 'package:crypto_app/feature/coin_detail/widgets/coin_detail_title.dart';
import 'package:crypto_app/feature/coin_detail/widgets/market_stats_card.dart';
import 'package:crypto_app/feature/coin_detail/widgets/market_stats_grid.dart';
import 'package:crypto_app/feature/coin_detail/widgets/time_range_selector.dart';
import 'package:flutter/material.dart';

class CoinDetailView extends StatefulWidget {
  const CoinDetailView({super.key});

  @override
  State<CoinDetailView> createState() => _CoinDetailViewState();
}

class _CoinDetailViewState extends State<CoinDetailView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CoinDetailCustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            SizedBox(height: 24),
            CoinDetailTitle(),
            CoinDetailGraph(),
            SizedBox(height: 24),
            TimeRangeSelector(),
            MarketStatsCard(),
            SizedBox(height: 16),
            MarketStatsGrid(),
          ],
        ),
      ),
      bottomNavigationBar: CoinDetailBottomNav(),
    );
  }
}
