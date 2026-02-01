import 'package:crypto_app/core/theme/app_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CoinDetailGraph extends StatelessWidget {
  const CoinDetailGraph({super.key});

  static const double _graphHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, right: 32),
      child: SizedBox(
        width: double.infinity,
        height: _graphHeight,
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
                  FlSpot(0, 1),
                  FlSpot(1, 1.5),
                  FlSpot(2, 1.2),
                  FlSpot(3, 2),
                  FlSpot(4, 2.5),
                  FlSpot(5, 2.3),
                ],
                isCurved: true,
                color: AppColors.primary,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.25),
                      AppColors.primary.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
