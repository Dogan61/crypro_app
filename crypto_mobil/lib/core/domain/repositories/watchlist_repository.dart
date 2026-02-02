import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class WatchlistRepository {
  /// Tüm favori sembolleri getir
  Future<Either<Failure, List<String>>> getWatchlist();

  /// Sembolü favorilere ekle (idempotent)
  Future<Either<Failure, List<String>>> addToWatchlist(String symbol);

  /// Sembolü favorilerden çıkar (idempotent)
  Future<Either<Failure, List<String>>> removeFromWatchlist(String symbol);
}

