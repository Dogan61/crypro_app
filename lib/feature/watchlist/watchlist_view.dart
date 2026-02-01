import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/constants/value_const.dart';
import 'package:crypto_app/core/navbar/custom_bottom_bar.dart';
import 'package:crypto_app/feature/home/widgets/home_view_filter.dart';
import 'package:crypto_app/feature/watchlist/widgets/favorites_card.dart';
import 'package:crypto_app/feature/watchlist/widgets/watch_list_app_bar.dart';
import 'package:crypto_app/feature/watchlist/widgets/watch_list_summary.dart';
import 'package:crypto_app/feature/watchlist/widgets/watch_list_title.dart';
import 'package:flutter/material.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({super.key});

  @override
  State<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends State<WatchListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WatchListAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            const WatchListSummary(),
            const SizedBox(height: 16),
            const HomeViewFilter(),
            const SizedBox(height: 16),
            const WatchListTitle(
              headerText: TextConst.favorites,
              buttonText: TextConst.edit,
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: ValueConst.homeListItemCount,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, __) => const FavoritesCard(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
