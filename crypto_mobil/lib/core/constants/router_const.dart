class RouterConst {
  RouterConst._();

  static const String home = '/';
  static const String coinDetail = '/coin/:symbol';
  static const String search = '/search';
  static const String watchlist = '/watchlist';
  static const String settings = '/settings';

  /// Coin detay sayfası için path oluşturur
  static String coinDetailPath(String symbol) => '/coin/$symbol';
}
