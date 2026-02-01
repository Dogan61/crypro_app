import 'package:crypto_app/core/constants/image_const.dart';
import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/extension/x_build_context.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeCoinCard extends StatelessWidget {
  const HomeCoinCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(ImageConst.avatar),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TextConst.bitcoin,
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  Text(TextConst.btc, style: context.theme.textTheme.bodySmall),
                ],
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
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 1.5),
                        FlSpot(2, 1.2),
                        FlSpot(3, 2),
                        FlSpot(4, 2.5),
                        FlSpot(5, 2.3),
                      ],
                      isCurved: true,
                      color: Colors.greenAccent,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.greenAccent.withOpacity(0.2),
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
                TextConst.initialBalance,
                style: context.theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
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
            ],
          ),
        ],
      ),
    );
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
