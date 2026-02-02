import 'package:crypto_mobil/feature/coin_detail/coin_detail_view.dart';
import 'package:crypto_mobil/feature/home/home_view.dart';
import 'package:crypto_mobil/feature/search/search_assets_view.dart';
import 'package:crypto_mobil/feature/settings/settings_view.dart';
import 'package:crypto_mobil/feature/watchlist/watchlist_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String coinDetail = '/coin/:symbol';
  static const String search = '/search';
  static const String watchlist = '/watchlist';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(path: home, builder: (context, state) => const HomeView()),
      GoRoute(
        path: '/coin/:symbol',
        builder: (context, state) {
          final symbol = state.pathParameters['symbol'] ?? 'BTCUSDT';
          return CoinDetailView(symbol: symbol);
        },
      ),
      GoRoute(
        path: search,
        builder: (context, state) => const SearchAssetsView(),
      ),
      GoRoute(
        path: watchlist,
        builder: (context, state) => const WatchListView(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
