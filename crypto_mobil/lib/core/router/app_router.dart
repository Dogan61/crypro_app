import 'package:crypto_mobil/core/constants/router_const.dart';
import 'package:crypto_mobil/feature/coin_detail/coin_detail_view.dart';
import 'package:crypto_mobil/feature/home/home_view.dart';
import 'package:crypto_mobil/feature/search/search_assets_view.dart';
import 'package:crypto_mobil/feature/settings/settings_view.dart';
import 'package:crypto_mobil/feature/watchlist/watchlist_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouterConst.home,
    routes: [
      GoRoute(
        path: RouterConst.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: RouterConst.coinDetail,
        builder: (context, state) {
          final symbol = state.pathParameters['symbol'] ?? 'BTCUSDT';
          return CoinDetailView(symbol: symbol);
        },
      ),
      GoRoute(
        path: RouterConst.search,
        builder: (context, state) => const SearchAssetsView(),
      ),
      GoRoute(
        path: RouterConst.watchlist,
        builder: (context, state) => const WatchListView(),
      ),
      GoRoute(
        path: RouterConst.settings,
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
