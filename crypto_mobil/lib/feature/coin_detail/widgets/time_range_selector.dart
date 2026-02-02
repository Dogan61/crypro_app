import 'package:flutter/material.dart';

class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({
    required this.selectedInterval,
    required this.onIntervalChanged,
    super.key,
  });
  
  final String selectedInterval;
  final void Function(String) onIntervalChanged;

  static const Map<String, String> _intervalMap = {
    '1m': '1m',
    '1h': '1H',
    '1d': '1D',
    '1w': '1W',
    '1M': '1M',
  };

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
        children: _intervalMap.entries.map((entry) {
          final isSelected = selectedInterval == entry.key;
          return GestureDetector(
            onTap: () => onIntervalChanged(entry.key),
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
                entry.value,
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
}
