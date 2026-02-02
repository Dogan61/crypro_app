import 'package:crypto_mobil/core/di/injection.dart';
import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/mixins/error_handler_mixin.dart';
import 'package:crypto_mobil/core/mixins/loading_mixin.dart';
import 'package:crypto_mobil/core/navbar/custom_bottom_bar.dart';
import 'package:crypto_mobil/feature/home/bloc/home_bloc.dart';
import 'package:crypto_mobil/feature/home/home_filter_mixin.dart';
import 'package:crypto_mobil/feature/home/widgets/home_app_bar.dart';
import 'package:crypto_mobil/feature/home/widgets/home_coin_card.dart';
import 'package:crypto_mobil/feature/home/widgets/home_view_filter.dart';
import 'package:crypto_mobil/feature/home/widgets/overview_card.dart';
import 'package:crypto_mobil/feature/watchlist/bloc/watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with LoadingMixin, ErrorHandlerMixin, MarketFilterMixin<HomeView> {
  late final HomeBloc _homeBloc;
  late final WatchlistBloc _watchlistBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = getIt<HomeBloc>();
    _watchlistBloc = getIt<WatchlistBloc>()..add(const LoadWatchlist());
    _homeBloc.add(const LoadMarketData());
  }

  @override
  void dispose() {
    _homeBloc.close();
    _watchlistBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>.value(value: _homeBloc),
        BlocProvider<WatchlistBloc>.value(value: _watchlistBloc),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.status == HomeStatus.failure) {
              showErrorSnackBar(
                context,
                state.errorMessage ?? 'Error loading data',
              );
            }
          },
          builder: (context, state) {
            if (state.status == HomeStatus.loading && state.prices.isEmpty) {
              return buildLoadingIndicator(message: 'Loading market data...');
            }

            if (state.status == HomeStatus.failure && state.prices.isEmpty) {
              return buildErrorWidget(
                message: state.errorMessage,
                onRetry: () => _homeBloc.add(const LoadMarketData()),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _homeBloc.add(const RefreshMarketData());
                // Wait for refresh to complete
                await _homeBloc.stream.firstWhere((s) => !s.isRefreshing);
              },
              child: Column(
                children: [
                  const Divider(thickness: 0.5, color: Colors.grey),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: OverviewCard(),
                  ),
                  const SizedBox(height: 16),
                  HomeViewFilter(
                    selected: selectedFilter,
                    onChanged: updateFilter,
                  ),
                  const SizedBox(height: 16),
                  const HomeHeaderText(),
                  const Divider(thickness: 0.5, color: Colors.grey),
                  Expanded(child: _buildFilteredList(state)),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: const CustomBottomBar(),
      ),
    );
  }

  Widget _buildFilteredList(HomeState state) {
    if (state.prices.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Watchlist filtresi seçiliyse, öncelikle watchlist sembollerini uygula
    final watchlistState = context.watch<WatchlistBloc>().state;
    List<PriceEntity> basePrices = state.prices;

    if (selectedFilter == MarketFilter.watchlist &&
        watchlistState.symbols.isNotEmpty) {
      basePrices = state.prices
          .where((p) => watchlistState.symbols.contains(p.symbol))
          .toList();
    }

    final filteredPrices = applyFilter(
      prices: basePrices,
      tickers: state.tickers,
    );

    if (filteredPrices.isEmpty) {
      return const Center(child: Text('No assets match this filter'));
    }

    return ListView.builder(
      itemCount: filteredPrices.length,
      itemBuilder: (context, index) {
        final price = filteredPrices[index];

        Ticker24hEntity? ticker;
        try {
          ticker = state.tickers.firstWhere((t) => t.symbol == price.symbol);
        } catch (_) {
          ticker = null;
        }

        final isFavorite =
            watchlistState.symbols.contains(price.symbol);

        return HomeCoinCard(
          symbol: price.symbol,
          price: price.price,
          priceChangePercent: ticker?.priceChangePercent ?? 0.0,
          isFavorite: isFavorite,
          onFavoriteToggle: () {
            context
                .read<WatchlistBloc>()
                .add(ToggleFavorite(price.symbol));
          },
          onTap: () {
            context.push('/coin/${price.symbol}');
          },
        );
      },
    );
  }

  // Filter logic moved into MarketFilterMixin
}
