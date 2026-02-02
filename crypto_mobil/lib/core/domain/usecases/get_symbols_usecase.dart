import 'package:crypto_mobil/core/domain/entities/symbol_entity.dart';
import 'package:crypto_mobil/core/domain/repositories/market_repository.dart';
import 'package:crypto_mobil/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSymbolsUseCase {
  GetSymbolsUseCase(this._repository);
  final MarketRepository _repository;

  Future<Either<Failure, List<SymbolEntity>>> call({
    String? search,
    int limit = 100,
    int offset = 0,
  }) {
    return _repository.getSymbols(search: search, limit: limit, offset: offset);
  }
}
