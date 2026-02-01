import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/extension/x_build_context.dart';
import 'package:flutter/material.dart';

class CoinDetailTitle extends StatelessWidget {
  const CoinDetailTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          TextConst.coinDetailPrice,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                TextConst.priceChange,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              TextConst.coinDetailTime,
              style: context.theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
