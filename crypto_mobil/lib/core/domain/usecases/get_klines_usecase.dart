import 'package:crypto_mobil/core/domain/entities/kline_entity.dart';
import 'package:crypto_mobil/core/domain/repositories/market_repository.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetKlinesUseCase {
  GetKlinesUseCase(this._repository);
  final MarketRepository _repository;

  Future<Either<Failure, List<KlineEntity>>> call({
    required String symbol,
    String interval = '1h',
    int limit = 100,
  }) {
    return _repository.getKlines(
      symbol: symbol,
      interval: interval,
      limit: limit,
    );
  }
}
