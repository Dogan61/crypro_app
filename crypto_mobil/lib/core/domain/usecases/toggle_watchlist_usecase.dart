import 'package:crypto_mobil/core/domain/repositories/watchlist_repository.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleWatchlistUseCase {
  ToggleWatchlistUseCase(this._repository);

  final WatchlistRepository _repository;

  Future<Either<Failure, List<String>>> call({
    required String symbol,
    required bool isCurrentlyFavorite,
  }) {
    if (isCurrentlyFavorite) {
      return _repository.removeFromWatchlist(symbol);
    } else {
      return _repository.addToWatchlist(symbol);
    }
  }
}

