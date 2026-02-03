import 'package:crypto_mobil/core/data/datasources/market_cache_datasource.dart';
import 'package:crypto_mobil/core/data/datasources/market_remote_datasource.dart';
import 'package:crypto_mobil/core/domain/entities/kline_entity.dart';
import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/entities/symbol_entity.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/domain/repositories/market_repository.dart';
import 'package:crypto_mobil/core/error/exceptions.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: MarketRepository)
class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl(this._remoteDataSource, this._cacheDataSource);
  final MarketRemoteDataSource _remoteDataSource;
  final MarketCacheDataSource _cacheDataSource;

  @override
  Future<Either<Failure, List<SymbolEntity>>> getSymbols({
    String? search,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final symbols = await _remoteDataSource.getSymbols(
        search: search,
        limit: limit,
        offset: offset,
      );
      return Right(symbols);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message, e.retryAfter));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PriceEntity>>> getPrices() async {
    try {
      final prices = await _remoteDataSource.getPrices();
      // Cache successful response
      await _cacheDataSource.cachePrices(prices);
      return Right(prices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get from cache when offline
      final cachedPrices = await _cacheDataSource.getCachedPrices();
      if (cachedPrices != null && cachedPrices.isNotEmpty) {
        return Right(cachedPrices);
      }
      return Left(NetworkFailure(e.message));
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message, e.retryAfter));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PriceEntity>> getSymbolPrice(String symbol) async {
    try {
      final price = await _remoteDataSource.getSymbolPrice(symbol);
      return Right(price);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message, e.retryAfter));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<KlineEntity>>> getKlines({
    required String symbol,
    String interval = '1h',
    int limit = 100,
  }) async {
    try {
      final klines = await _remoteDataSource.getKlines(
        symbol: symbol,
        interval: interval,
        limit: limit,
      );
      return Right(klines);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message, e.retryAfter));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ticker24hEntity>>> getTicker24h({
    List<String>? symbols,
  }) async {
    try {
      final tickers = await _remoteDataSource.getTicker24h(symbols: symbols);
      // Cache successful response
      await _cacheDataSource.cacheTickers24h(tickers);
      return Right(tickers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get from cache when offline
      final cachedTickers = await _cacheDataSource.getCachedTickers24h();
      if (cachedTickers != null && cachedTickers.isNotEmpty) {
        return Right(cachedTickers);
      }
      return Left(NetworkFailure(e.message));
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message, e.retryAfter));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<PriceEntity> subscribeToPriceUpdates(List<String> symbols) {
    return _remoteDataSource.subscribeToPriceUpdates(symbols);
  }

  @override
  void unsubscribeFromPriceUpdates(List<String> symbols) {
    _remoteDataSource.unsubscribeFromPriceUpdates(symbols);
  }
}
