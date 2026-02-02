import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<String>>> getWatchlist();

  Future<Either<Failure, List<String>>> addToWatchlist(String symbol);

  Future<Either<Failure, List<String>>> removeFromWatchlist(String symbol);
}
