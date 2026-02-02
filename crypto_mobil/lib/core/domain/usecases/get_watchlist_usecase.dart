import 'package:crypto_mobil/core/domain/repositories/watchlist_repository.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetWatchlistUseCase {
  GetWatchlistUseCase(this._repository);

  final WatchlistRepository _repository;

  Future<Either<Failure, List<String>>> call() {
    return _repository.getWatchlist();
  }
}

