import 'package:crypto_app/feature/home/widgets/home_view_filter.dart';
import 'package:crypto_app/feature/search/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

class SearchAssetFirstContent extends StatelessWidget {
  const SearchAssetFirstContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xff101622),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: const Column(
        children: [
          CustomSearchBar(),
          SizedBox(height: 24),
          HomeViewFilter(),
        ],
      ),
    );
  }
}
