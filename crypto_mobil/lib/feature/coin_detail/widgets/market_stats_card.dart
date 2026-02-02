import 'package:crypto_mobil/core/constants/text_const.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:flutter/material.dart';

class MarketStatsCard extends StatelessWidget {
  const MarketStatsCard({required this.ticker, super.key});
  final Ticker24hEntity ticker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 32),
      child: Row(
        children: [
          Text(
            TextConst.marketStats,
            style: context.theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
