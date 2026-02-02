import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:crypto_mobil/core/theme/app_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WatchListSummary extends StatelessWidget {
  const WatchListSummary({
    required this.title,
    required this.balanceText,
    required this.changeBadgeText,
    required this.todayChangeText,
    this.isPositive = true,
    this.spots,
    super.key,
  });

  final String title;
  final String balanceText;
  final String changeBadgeText;
  final String todayChangeText;
  final bool isPositive;
  final List<FlSpot>? spots;

  @override
  Widget build(BuildContext context) {
    final points = spots ??
        const [
          FlSpot(0, 3),
          FlSpot(1, 1.5),
          FlSpot(2, 3.2),
          FlSpot(3, 1),
          FlSpot(4, 2),
          FlSpot(5, 2.3),
        ];

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
                  title,
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  balanceText,
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
                        color:
                            (isPositive ? Colors.green : Colors.red).withOpacity(
                          0.4,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        changeBadgeText,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isPositive ? Colors.greenAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      todayChangeText,
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
                  maxX: points.length.toDouble() - 1,
                  minY: 0,
                  maxY: 3,
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: points,
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
