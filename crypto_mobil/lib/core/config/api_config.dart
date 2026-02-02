import 'package:crypto_mobil/core/config/env.dart';

/// API configuration
class ApiConfig {
  ApiConfig._();

  // Base URLs
  static String get baseUrl => Env.apiBaseUrl;

  static const String apiPrefix = '/api';

  // Endpoints
  static const String marketSymbols = '$apiPrefix/market/symbols';
  static const String marketPrices = '$apiPrefix/market/prices';
  static const String marketKlines = '$apiPrefix/market/klines';
  static const String marketTicker24h = '$apiPrefix/market/ticker/24h';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Socket.IO
  static const String socketNamespace = '/';

  // Cache
  static const Duration symbolsCacheDuration = Duration(hours: 1);
  static const Duration pricesCacheDuration = Duration(seconds: 2);
}
