import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_mobil/core/constants/text_const.dart';
import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:crypto_mobil/core/utils/coin_image_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeCoinCard extends StatelessWidget {
  const HomeCoinCard({
    required this.symbol,
    required this.price,
    required this.priceChangePercent,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onTap,
    super.key,
  });
  final String symbol;
  final String price;
  final double priceChangePercent;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isPositive = priceChangePercent >= 0;
    final baseAsset = symbol.replaceAll('USDT', '');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white.withOpacity(0.01),
                  child: CachedNetworkImage(
                    imageUrl: CoinImageHelper.getCoinIconUrl(symbol),
                    width: 30,
                    height: 30,
                    placeholder: (context, url) => const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => Text(
                      CoinImageHelper.getCoinSymbolText(symbol),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(baseAsset, style: context.theme.textTheme.bodyLarge),
                    Text(symbol, style: context.theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.amber : Colors.grey,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onFavoriteToggle,
                ),
              ],
            ),

            const SizedBox(width: 12),

            Expanded(
              child: SizedBox(
                height: 40,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 5,
                    minY: 0,
                    maxY: 3,
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: isPositive
                            ? const [
                                FlSpot(0, 1),
                                FlSpot(1, 1.2),
                                FlSpot(2, 1.4),
                                FlSpot(3, 1.8),
                                FlSpot(4, 2.2),
                                FlSpot(5, 2.6),
                              ]
                            : const [
                                FlSpot(0, 2.6),
                                FlSpot(1, 2.2),
                                FlSpot(2, 1.8),
                                FlSpot(3, 1.4),
                                FlSpot(4, 1.2),
                                FlSpot(5, 1),
                              ],
                        isCurved: true,
                        color: isPositive
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color:
                              (isPositive
                                      ? Colors.greenAccent
                                      : Colors.redAccent)
                                  .withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${_formatPrice(price)}',
                  style: context.theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${priceChangePercent.toStringAsFixed(2)}%',
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(String price) {
    final priceDouble = double.tryParse(price) ?? 0.0;

    // If price is very small (< 0.01), show 6 decimals
    if (priceDouble < 0.01) {
      return priceDouble
          .toStringAsFixed(6)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }

    // If price is small (< 1), show 4 decimals
    if (priceDouble < 1) {
      return priceDouble
          .toStringAsFixed(4)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }

    // Otherwise show 2 decimals
    return priceDouble.toStringAsFixed(2);
  }
}

class HomeHeaderText extends StatelessWidget {
  const HomeHeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(TextConst.assets, style: context.theme.textTheme.bodyLarge),
          Text(TextConst.charts, style: context.theme.textTheme.bodyLarge),
          Text(TextConst.price, style: context.theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
