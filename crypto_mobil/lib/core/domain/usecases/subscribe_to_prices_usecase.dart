import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/repositories/market_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubscribeToPricesUseCase {
  SubscribeToPricesUseCase(this._repository);
  final MarketRepository _repository;

  Stream<PriceEntity> call(List<String> symbols) {
    return _repository.subscribeToPriceUpdates(symbols);
  }

  void unsubscribe(List<String> symbols) {
    _repository.unsubscribeFromPriceUpdates(symbols);
  }
}
