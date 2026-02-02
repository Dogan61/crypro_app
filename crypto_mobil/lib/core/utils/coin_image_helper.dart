/// Helper for coin icon URLs
class CoinImageHelper {
  CoinImageHelper._();

  /// Get coin icon URL from CoinCap CDN
  static String getCoinIconUrl(String symbol) {
    final upper = symbol.toUpperCase();
    String base;

    // Stable-coin quote çiftleri (BTCUSDT, ETHUSDC, vb.)
    if (upper.endsWith('USDT')) {
      base = upper.substring(0, upper.length - 4);
    } else if (upper.endsWith('USDC')) {
      base = upper.substring(0, upper.length - 4);
    } else if (upper.endsWith('FDUSD')) {
      base = upper.substring(0, upper.length - 5);
    }
    // BTC / ETH / BNB quote çiftleri (ETHBTC, BNBBTC, vb.)
    else if (upper.endsWith('BTC') && upper != 'BTC') {
      base = upper.substring(0, upper.length - 3);
    } else if (upper.endsWith('ETH') && upper != 'ETH') {
      base = upper.substring(0, upper.length - 3);
    } else if (upper.endsWith('BNB') && upper != 'BNB') {
      base = upper.substring(0, upper.length - 3);
    } else {
      // Zaten tek sembol ya da farklı bir çift
      base = upper;
    }

    if (base.isEmpty) {
      base = upper;
    }

    return _getUrl(base.toLowerCase());
  }

  static String _getUrl(String symbol) {
    return 'https://assets.coincap.io/assets/icons/${symbol.toLowerCase()}@2x.png';
  }

  /// Fallback icon when image fails to load
  static String getCoinSymbolText(String symbol) {
    final coinSymbol = symbol
        .replaceAll('USDT', '')
        .replaceAll('USDC', '')
        .replaceAll('FDUSD', '');

    return coinSymbol.substring(
      0,
      coinSymbol.length >= 3 ? 3 : coinSymbol.length,
    );
  }
}
