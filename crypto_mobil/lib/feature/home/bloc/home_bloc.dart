import 'dart:async';

import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/domain/usecases/get_prices_usecase.dart';
import 'package:crypto_mobil/core/domain/usecases/get_ticker_24h_usecase.dart';
import 'package:crypto_mobil/core/domain/usecases/subscribe_to_prices_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._getPricesUseCase,
    this._getTicker24hUseCase,
    this._subscribeToPricesUseCase,
  ) : super(const HomeState()) {
    on<LoadMarketData>(_onLoadMarketData);
    on<RefreshMarketData>(_onRefreshMarketData);
    on<SubscribeToRealtimePrices>(_onSubscribeToRealtimePrices);
    on<UnsubscribeFromRealtimePrices>(_onUnsubscribeFromRealtimePrices);
    on<UpdateRealtimePrice>(_onUpdateRealtimePrice);
  }
  final GetPricesUseCase _getPricesUseCase;
  final GetTicker24hUseCase _getTicker24hUseCase;
  final SubscribeToPricesUseCase _subscribeToPricesUseCase;

  StreamSubscription<PriceEntity>? _priceSubscription;

  Future<void> _onLoadMarketData(
    LoadMarketData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final pricesResult = await _getPricesUseCase();
    final tickersResult = await _getTicker24hUseCase();

    pricesResult.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (prices) async {
        tickersResult.fold(
          (failure) => emit(
            state.copyWith(
              status: HomeStatus.success,
              prices: prices,
              errorMessage: 'Could not load ticker data',
            ),
          ),
          (tickers) {
            emit(
              state.copyWith(
                status: HomeStatus.success,
                prices: prices,
                tickers: tickers,
              ),
            );

            final symbols = prices.map((p) => p.symbol).toList();
            if (symbols.isNotEmpty) {
              add(SubscribeToRealtimePrices(symbols));
            }
          },
        );
      },
    );
  }

  Future<void> _onRefreshMarketData(
    RefreshMarketData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    final pricesResult = await _getPricesUseCase();
    final tickersResult = await _getTicker24hUseCase();

    pricesResult.fold(
      (failure) => emit(
        state.copyWith(isRefreshing: false, errorMessage: failure.message),
      ),
      (prices) {
        tickersResult.fold(
          (failure) =>
              emit(state.copyWith(isRefreshing: false, prices: prices)),
          (tickers) {
            emit(
              state.copyWith(
                isRefreshing: false,
                prices: prices,
                tickers: tickers,
              ),
            );

            final symbols = prices.map((p) => p.symbol).toList();
            if (symbols.isNotEmpty) {
              add(UnsubscribeFromRealtimePrices(symbols));
              add(SubscribeToRealtimePrices(symbols));
            }
          },
        );
      },
    );
  }

  Future<void> _onSubscribeToRealtimePrices(
    SubscribeToRealtimePrices event,
    Emitter<HomeState> emit,
  ) async {
    await _priceSubscription?.cancel();

    _priceSubscription = _subscribeToPricesUseCase(event.symbols).listen((
      price,
    ) {
      add(UpdateRealtimePrice(price));
    });
  }

  void _onUnsubscribeFromRealtimePrices(
    UnsubscribeFromRealtimePrices event,
    Emitter<HomeState> emit,
  ) {
    _subscribeToPricesUseCase.unsubscribe(event.symbols);
  }

  void _onUpdateRealtimePrice(
    UpdateRealtimePrice event,
    Emitter<HomeState> emit,
  ) {
    final updatedPrices = state.prices.map((price) {
      if (price.symbol == event.price.symbol) {
        return event.price;
      }
      return price;
    }).toList();

    emit(state.copyWith(prices: updatedPrices));
  }

  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    return super.close();
  }
}
