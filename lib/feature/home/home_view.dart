import 'package:crypto_app/core/constants/value_const.dart';
import 'package:crypto_app/core/navbar/custom_bottom_bar.dart';
import 'package:crypto_app/feature/home/widgets/home_app_bar.dart';
import 'package:crypto_app/feature/home/widgets/home_coin_card.dart';
import 'package:crypto_app/feature/home/widgets/home_view_filter.dart';
import 'package:crypto_app/feature/home/widgets/overview_card.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          const Divider(thickness: 0.5, color: Colors.grey),
          const Padding(
            padding: EdgeInsets.all(16),
            child: OverviewCard(),
          ),
          const SizedBox(height: 16),
          const HomeViewFilter(),
          const SizedBox(height: 16),
          const HomeHeaderText(),
          const Divider(thickness: 0.5, color: Colors.grey),
          Expanded(
            child: ListView.builder(
              itemCount: ValueConst.homeListItemCount,
              itemBuilder: (context, index) => const HomeCoinCard(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
