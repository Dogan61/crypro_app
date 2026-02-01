import 'package:crypto_app/core/navbar/custom_bottom_bar.dart';
import 'package:crypto_app/feature/search/widgets/search_asset_first_content.dart';
import 'package:crypto_app/feature/search/widgets/search_asset_second_content.dart';
import 'package:crypto_app/feature/search/widgets/search_view_custom_app_bar.dart';
import 'package:flutter/material.dart';

class SearchAssetsView extends StatefulWidget {
  const SearchAssetsView({super.key});

  @override
  State<SearchAssetsView> createState() => _SearchAssetsViewState();
}

class _SearchAssetsViewState extends State<SearchAssetsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SearchViewCustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchAssetFirstContent(),
            SearchAssetSecondContent(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
