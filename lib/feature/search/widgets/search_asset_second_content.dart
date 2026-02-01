import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/extension/x_build_context.dart';
import 'package:crypto_app/feature/search/widgets/recent_search_card.dart';
import 'package:crypto_app/feature/watchlist/widgets/favorites_card.dart';
import 'package:crypto_app/feature/watchlist/widgets/watch_list_title.dart';
import 'package:flutter/material.dart';

class SearchAssetSecondContent extends StatelessWidget {
  const SearchAssetSecondContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const WatchListTitle(
            headerText: TextConst.recentSearches,
            buttonText: TextConst.clear,
          ),
          const SizedBox(height: 8),
          const RecentSearchCard(),
          const SizedBox(height: 8),
          const RecentSearchCard(),
          const SizedBox(height: 8),
          const RecentSearchCard(),
          const SizedBox(height: 16),
          Text(
            TextConst.trendingAssets,
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const FavoritesCard(),
          const SizedBox(height: 8),
          const FavoritesCard(),
          const SizedBox(height: 8),
          const FavoritesCard(),
        ],
      ),
    );
  }
}
