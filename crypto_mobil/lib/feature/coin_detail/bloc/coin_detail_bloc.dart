import 'dart:async';

import 'package:crypto_mobil/core/domain/entities/kline_entity.dart';
import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/domain/usecases/get_klines_usecase.dart';
import 'package:crypto_mobil/core/domain/usecases/get_ticker_24h_usecase.dart';
import 'package:crypto_mobil/core/domain/usecases/subscribe_to_prices_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'coin_detail_event.dart';
part 'coin_detail_state.dart';

@injectable
class CoinDetailBloc extends Bloc<CoinDetailEvent, CoinDetailState> {
  CoinDetailBloc(
    this._getKlinesUseCase,
    this._getTicker24hUseCase,
    this._subscribeToPricesUseCase,
  ) : super(const CoinDetailState()) {
    on<LoadCoinDetail>(_onLoadCoinDetail);
    on<ChangeTimeInterval>(_onChangeTimeInterval);
    on<SubscribeToCoinPrice>(_onSubscribeToCoinPrice);
    on<UpdateCoinPrice>(_onUpdateCoinPrice);
  }
  final GetKlinesUseCase _getKlinesUseCase;
  final GetTicker24hUseCase _getTicker24hUseCase;
  final SubscribeToPricesUseCase _subscribeToPricesUseCase;

  StreamSubscription<PriceEntity>? _priceSubscription;

  Future<void> _onLoadCoinDetail(
    LoadCoinDetail event,
    Emitter<CoinDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: CoinDetailStatus.loading, symbol: event.symbol),
    );

    final klinesResult = await _getKlinesUseCase(
      symbol: event.symbol,
      interval: state.selectedInterval,
    );

    final tickerResult = await _getTicker24hUseCase(symbols: [event.symbol]);

    klinesResult.fold(
      (failure) => emit(
        state.copyWith(
          status: CoinDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (klines) {
        tickerResult.fold(
          (failure) => emit(
            state.copyWith(
              status: CoinDetailStatus.success,
              klines: klines,
              errorMessage: 'Could not load ticker data',
            ),
          ),
          (tickers) => emit(
            state.copyWith(
              status: CoinDetailStatus.success,
              klines: klines,
              ticker: tickers.isNotEmpty ? tickers.first : null,
            ),
          ),
        );
      },
    );

    // Subscribe to realtime price
    add(SubscribeToCoinPrice(event.symbol));
  }

  Future<void> _onChangeTimeInterval(
    ChangeTimeInterval event,
    Emitter<CoinDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CoinDetailStatus.loading,
        selectedInterval: event.interval,
      ),
    );

    final klinesResult = await _getKlinesUseCase(
      symbol: state.symbol,
      interval: event.interval,
    );

    klinesResult.fold(
      (failure) => emit(
        state.copyWith(
          status: CoinDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (klines) => emit(
        state.copyWith(status: CoinDetailStatus.success, klines: klines),
      ),
    );
  }

  Future<void> _onSubscribeToCoinPrice(
    SubscribeToCoinPrice event,
    Emitter<CoinDetailState> emit,
  ) async {
    await _priceSubscription?.cancel();

    _priceSubscription = _subscribeToPricesUseCase([event.symbol]).listen((
      price,
    ) {
      add(UpdateCoinPrice(price));
    });
  }

  void _onUpdateCoinPrice(
    UpdateCoinPrice event,
    Emitter<CoinDetailState> emit,
  ) {
    emit(state.copyWith(currentPrice: event.price));
  }

  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    if (state.symbol.isNotEmpty) {
      _subscribeToPricesUseCase.unsubscribe([state.symbol]);
    }
    return super.close();
  }
}
