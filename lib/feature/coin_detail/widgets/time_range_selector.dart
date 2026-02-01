import 'package:crypto_app/core/constants/text_const.dart';
import 'package:flutter/material.dart';

enum TimeRange { oneH, oneD, oneW, oneM, oneY, all }

class TimeRangeSelector extends StatefulWidget {
  const TimeRangeSelector({super.key});

  @override
  State<TimeRangeSelector> createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  TimeRange selectedRange = TimeRange.oneD;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: TimeRange.values.map((range) {
          final isSelected = selectedRange == range;
          return GestureDetector(
            onTap: () => setState(() => selectedRange = range),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF3B52E1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _getRangeText(range),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getRangeText(TimeRange range) {
    switch (range) {
      case TimeRange.oneH:
        return TextConst.timeRange1H;
      case TimeRange.oneD:
        return TextConst.timeRange1D;
      case TimeRange.oneW:
        return TextConst.timeRange1W;
      case TimeRange.oneM:
        return TextConst.timeRange1M;
      case TimeRange.oneY:
        return TextConst.timeRange1Y;
      case TimeRange.all:
        return TextConst.timeRangeAll;
    }
  }
}
