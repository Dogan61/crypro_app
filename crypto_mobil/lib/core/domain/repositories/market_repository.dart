import 'package:crypto_mobil/core/domain/entities/kline_entity.dart';
import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/entities/symbol_entity.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class MarketRepository {
  /// Get all trading symbols
  Future<Either<Failure, List<SymbolEntity>>> getSymbols({
    String? search,
    int limit = 100,
    int offset = 0,
  });

  /// Get all prices
  Future<Either<Failure, List<PriceEntity>>> getPrices();

  /// Get price for a specific symbol
  Future<Either<Failure, PriceEntity>> getSymbolPrice(String symbol);

  /// Get klines (candlestick data)
  Future<Either<Failure, List<KlineEntity>>> getKlines({
    required String symbol,
    String interval = '1h',
    int limit = 100,
  });

  /// Get 24h ticker statistics
  Future<Either<Failure, List<Ticker24hEntity>>> getTicker24h({
    List<String>? symbols,
  });

  /// Subscribe to price updates via Socket.IO
  Stream<PriceEntity> subscribeToPriceUpdates(List<String> symbols);

  /// Unsubscribe from price updates
  void unsubscribeFromPriceUpdates(List<String> symbols);
}
