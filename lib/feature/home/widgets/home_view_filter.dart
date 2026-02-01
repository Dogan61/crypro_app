import 'package:crypto_app/core/constants/text_const.dart';
import 'package:flutter/material.dart';

enum MarketFilter { all, gainers, losers, watchlist }

class FilterItem {
  const FilterItem(this.type, this.label);
  final MarketFilter type;
  final String label;
}

const List<FilterItem> homeFilters = [
  FilterItem(MarketFilter.all, TextConst.filterAllAssets),
  FilterItem(MarketFilter.gainers, TextConst.filterGainers),
  FilterItem(MarketFilter.losers, TextConst.filterLosers),
  FilterItem(MarketFilter.watchlist, TextConst.filterWatchlist),
];

class HomeViewFilter extends StatefulWidget {
  const HomeViewFilter({super.key});

  @override
  State<HomeViewFilter> createState() => _HomeViewFilterState();
}

class _HomeViewFilterState extends State<HomeViewFilter> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: homeFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = homeFilters[index];
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF135BEC)
                    : const Color(0xFF181A20),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.08),
                ),
              ),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[300],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
