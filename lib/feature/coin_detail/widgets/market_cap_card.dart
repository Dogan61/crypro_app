import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/extension/x_build_context.dart';
import 'package:flutter/material.dart';

class MarketCapCard extends StatelessWidget {
  const MarketCapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(Icons.pie_chart, size: 24, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                TextConst.marketCap,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 1,
                  fontFeatures: [FontFeature.enable('c2sc')],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            TextConst.marketCapValue,
            style: context.theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            TextConst.marketCapChange,
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.green,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
