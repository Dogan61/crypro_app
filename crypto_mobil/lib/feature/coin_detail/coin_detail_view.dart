import 'package:crypto_mobil/core/di/injection.dart';
import 'package:crypto_mobil/core/mixins/error_handler_mixin.dart';
import 'package:crypto_mobil/core/mixins/loading_mixin.dart';
import 'package:crypto_mobil/feature/coin_detail/bloc/coin_detail_bloc.dart';
import 'package:crypto_mobil/feature/coin_detail/widgets/coin_detail_bottom_nav.dart';
import 'package:crypto_mobil/feature/coin_detail/widgets/coin_detail_custom_appbar.dart';
import 'package:crypto_mobil/feature/coin_detail/widgets/coin_detail_graph.dart';
import 'package:crypto_mobil/feature/coin_detail/widgets/coin_detail_title.dart';
import 'package:crypto_mobil/feature/coin_detail/widgets/market_stats_card.dart';
import 'package:crypto_mobil/feature/coin_detail/widgets/market_stats_grid.dart';
import 'package:crypto_mobil/feature/coin_detail/widgets/time_range_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinDetailView extends StatefulWidget {
  const CoinDetailView({required this.symbol, super.key});
  final String symbol;

  @override
  State<CoinDetailView> createState() => _CoinDetailViewState();
}

class _CoinDetailViewState extends State<CoinDetailView>
    with LoadingMixin, ErrorHandlerMixin {
  late final CoinDetailBloc _coinDetailBloc;

  @override
  void initState() {
    super.initState();
    _coinDetailBloc = getIt<CoinDetailBloc>();
    _coinDetailBloc.add(LoadCoinDetail(widget.symbol));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _coinDetailBloc,
      child: Scaffold(
        appBar: CoinDetailCustomAppBar(symbol: widget.symbol),
        body: BlocConsumer<CoinDetailBloc, CoinDetailState>(
          listener: (context, state) {
            if (state.status == CoinDetailStatus.failure) {
              showErrorSnackBar(
                context,
                state.errorMessage ?? 'Error loading coin data',
              );
            }
          },
          builder: (context, state) {
            if (state.status == CoinDetailStatus.loading &&
                state.klines.isEmpty) {
              return buildLoadingIndicator(
                message: 'Loading ${widget.symbol}...',
              );
            }

            if (state.status == CoinDetailStatus.failure &&
                state.klines.isEmpty) {
              return buildErrorWidget(
                message: state.errorMessage,
                onRetry: () =>
                    _coinDetailBloc.add(LoadCoinDetail(widget.symbol)),
              );
            }

            // Başlıkta gösterilecek fiyat:
            // 1) Realtime currentPrice varsa onu,
            // 2) Yoksa 24h ticker.lastPrice'ı,
            // 3) O da yoksa 0.00 göster.
            final displayPrice = state.currentPrice?.formattedPrice ??
                (state.ticker != null
                    ? state.ticker!.lastPrice.toString()
                    : '0.00');

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  CoinDetailTitle(
                    symbol: widget.symbol,
                    price: displayPrice,
                  ),
                  if (state.klines.isNotEmpty)
                    CoinDetailGraph(klines: state.klines)
                  else
                    const SizedBox(
                      height: 200,
                      child: Center(child: Text('No chart data')),
                    ),
                  const SizedBox(height: 24),
                  TimeRangeSelector(
                    selectedInterval: state.selectedInterval,
                    onIntervalChanged: (interval) {
                      _coinDetailBloc.add(ChangeTimeInterval(interval));
                    },
                  ),
                  if (state.ticker != null) ...[
                    MarketStatsCard(ticker: state.ticker!),
                    const SizedBox(height: 16),
                    MarketStatsGrid(ticker: state.ticker!),
                  ],
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: const CoinDetailBottomNav(),
      ),
    );
  }

  @override
  void dispose() {
    _coinDetailBloc.close();
    super.dispose();
  }
}
