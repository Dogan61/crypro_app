import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/extension/x_build_context.dart';
import 'package:crypto_app/core/theme/app_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WatchListSummary extends StatelessWidget {
  const WatchListSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextConst.totalBalance,
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  TextConst.watchlistBalance,
                  style: context.theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        TextConst.priceChange24h,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      TextConst.todayChange,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 100,
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
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(1, 1.5),
                        FlSpot(2, 3.2),
                        FlSpot(3, 1),
                        FlSpot(4, 2),
                        FlSpot(5, 2.3),
                      ],
                      isCurved: true,
                      color: AppColors.primary.withOpacity(0.3),
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.primary.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
