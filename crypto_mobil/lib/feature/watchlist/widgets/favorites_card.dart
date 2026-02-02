import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:crypto_mobil/core/utils/coin_image_helper.dart';
import 'package:flutter/material.dart';

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({
    required this.title,
    required this.symbol,
    required this.priceText,
    required this.changeText,
    this.isPositive = true,
    this.onTap,
    super.key,
  });

  final String title;
  final String symbol;
  final String priceText;
  final String changeText;
  final bool isPositive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(0.05),
              child: CachedNetworkImage(
                imageUrl: CoinImageHelper.getCoinIconUrl(symbol),
                width: 28,
                height: 28,
                errorWidget: (context, url, error) => Text(
                  CoinImageHelper.getCoinSymbolText(symbol),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Text(
                  symbol,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  priceText,
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  changeText,
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                        color: isPositive ? Colors.green : Colors.red,
                        height: 1,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
