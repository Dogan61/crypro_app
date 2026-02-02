import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/repositories/market_repository.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPricesUseCase {
  GetPricesUseCase(this._repository);
  final MarketRepository _repository;

  Future<Either<Failure, List<PriceEntity>>> call() {
    return _repository.getPrices();
  }
}
