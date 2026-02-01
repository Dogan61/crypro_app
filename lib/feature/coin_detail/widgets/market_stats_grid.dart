import 'package:crypto_app/core/constants/value_const.dart';
import 'package:crypto_app/feature/coin_detail/widgets/market_cap_card.dart';
import 'package:flutter/material.dart';

class MarketStatsGrid extends StatelessWidget {
  const MarketStatsGrid({super.key});

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
        children: List.generate(
          ValueConst.marketStatsGridCount,
          (_) => const MarketCapCard(),
        ),
      ),
    );
  }
}
