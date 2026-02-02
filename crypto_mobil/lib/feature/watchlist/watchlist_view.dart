import 'package:crypto_mobil/core/constants/text_const.dart';
import 'package:crypto_mobil/core/constants/value_const.dart';
import 'package:crypto_mobil/core/navbar/custom_bottom_bar.dart';
import 'package:crypto_mobil/feature/home/home_filter_mixin.dart';
import 'package:crypto_mobil/feature/home/widgets/home_view_filter.dart';
import 'package:crypto_mobil/feature/watchlist/widgets/favorites_card.dart';
import 'package:crypto_mobil/feature/watchlist/widgets/watch_list_app_bar.dart';
import 'package:crypto_mobil/feature/watchlist/widgets/watch_list_summary.dart';
import 'package:crypto_mobil/feature/watchlist/widgets/watch_list_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_mobil/core/di/injection.dart';
import 'package:crypto_mobil/feature/watchlist/bloc/watchlist_bloc.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({super.key});

  @override
  State<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends State<WatchListView>
    with MarketFilterMixin<WatchListView> {
  late final WatchlistBloc _watchlistBloc;

  @override
  void initState() {
    super.initState();
    _watchlistBloc = getIt<WatchlistBloc>()..add(const LoadWatchlist());
    // Varsayılan olarak watchlist filtresi seçili gelsin
    selectedFilter = MarketFilter.watchlist;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _watchlistBloc,
      child: Scaffold(
        appBar: const WatchListAppBar(),
        body: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, state) {
              final isLoading = state.status == WatchlistStatus.loading;
              final hasError =
                  state.status == WatchlistStatus.failure && state.symbols.isEmpty;

              if (isLoading && state.symbols.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (hasError) {
                return Center(
                  child: Text(state.errorMessage ?? 'Watchlist yüklenemedi'),
                );
              }

              return Column(
                children: [
                  WatchListSummary(
                    title: TextConst.totalBalance,
                    balanceText: TextConst.watchlistBalance,
                    changeBadgeText: TextConst.priceChange24h,
                    todayChangeText: TextConst.todayChange,
                  ),
                  const SizedBox(height: 16),
                  HomeViewFilter(
                    selected: selectedFilter,
                    onChanged: (filter) {
                      updateFilter(filter);
                      // Filtre mantığı: MarketFilterMixin + state.symbols ileride
                    },
                  ),
                  const SizedBox(height: 16),
                  const WatchListTitle(
                    headerText: TextConst.favorites,
                    buttonText: TextConst.edit,
                  ),
                  Expanded(
                    child: state.symbols.isEmpty
                        ? const Center(child: Text('Henüz favori eklenmemiş'))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.symbols.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final symbol = state.symbols[index];
                              final price = state.prices
                                  .where((p) => p.symbol == symbol)
                                  .firstOrNull;
                              final ticker = state.tickers
                                  .where((t) => t.symbol == symbol)
                                  .firstOrNull;

                              final priceText =
                                  price != null ? '\$${price.formattedPrice}' : '-';
                              final changePercent =
                                  ticker?.priceChangePercent ?? 0.0;
                              final isPositive = changePercent >= 0;

                              return FavoritesCard(
                                title: symbol.replaceAll('USDT', ''),
                                symbol: symbol,
                                priceText: priceText,
                                changeText:
                                    '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
                                isPositive: isPositive,
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: const CustomBottomBar(),
      ),
    );
  }

  @override
  void dispose() {
    _watchlistBloc.close();
    super.dispose();
  }
}
