import 'package:crypto_mobil/core/domain/entities/kline_entity.dart';
import 'package:crypto_mobil/core/theme/app_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CoinDetailGraph extends StatelessWidget {
  const CoinDetailGraph({required this.klines, super.key});
  final List<KlineEntity> klines;

  static const double _graphHeight = 200;

  @override
  Widget build(BuildContext context) {
    if (klines.isEmpty) {
      return const SizedBox(
        height: _graphHeight,
        child: Center(child: Text('No chart data available')),
      );
    }

    final spots = klines.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.close);
    }).toList();

    final minY = klines.map((k) => k.low).reduce((a, b) => a < b ? a : b);
    final maxY = klines.map((k) => k.high).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.only(top: 32, right: 32),
      child: SizedBox(
        width: double.infinity,
        height: _graphHeight,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (klines.length - 1).toDouble(),
            minY: minY * 0.99,
            maxY: maxY * 1.01,
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
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
