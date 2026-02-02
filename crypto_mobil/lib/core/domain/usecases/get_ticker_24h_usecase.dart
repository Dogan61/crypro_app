import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/domain/repositories/market_repository.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTicker24hUseCase {
  GetTicker24hUseCase(this._repository);
  final MarketRepository _repository;

  Future<Either<Failure, List<Ticker24hEntity>>> call({List<String>? symbols}) {
    return _repository.getTicker24h(symbols: symbols);
  }
}
