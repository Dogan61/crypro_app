import 'package:crypto_mobil/core/data/datasources/local_storage_datasource.dart';
import 'package:crypto_mobil/core/domain/repositories/watchlist_repository.dart';
import 'package:crypto_mobil/core/error/exceptions.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

const _kWatchlistKey = 'watchlist_symbols';

@LazySingleton(as: WatchlistRepository)
class WatchlistRepositoryImpl implements WatchlistRepository {
  WatchlistRepositoryImpl(this._localStorage);

  final LocalStorageDataSource _localStorage;

  @override
  Future<Either<Failure, List<String>>> getWatchlist() async {
    try {
      final symbols = await _localStorage.getStringList(_kWatchlistKey) ?? [];
      return Right(symbols);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> addToWatchlist(String symbol) async {
    try {
      final current = await _localStorage.getStringList(_kWatchlistKey) ?? [];
      if (!current.contains(symbol)) {
        current.add(symbol);
        await _localStorage.saveStringList(_kWatchlistKey, current);
      }
      return Right(current);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> removeFromWatchlist(
    String symbol,
  ) async {
    try {
      final current = await _localStorage.getStringList(_kWatchlistKey) ?? [];
      current.remove(symbol);
      await _localStorage.saveStringList(_kWatchlistKey, current);
      return Right(current);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

