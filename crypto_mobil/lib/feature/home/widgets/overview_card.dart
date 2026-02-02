import 'package:crypto_mobil/core/constants/text_const.dart';
import 'package:crypto_mobil/core/constants/value_const.dart';
import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TextConst.globalMarketCap,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                TextConst.volume24h,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TextConst.priceChange,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                TextConst.overviewVolume,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TextConst.btcDominance,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                TextConst.eth,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(
            backgroundColor: Colors.blue,
            value: ValueConst.btcDominanceProgress,
          ),
        ],
      ),
    );
  }
}
