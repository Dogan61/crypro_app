import 'dart:async';

import 'package:crypto_mobil/core/config/api_config.dart';
import 'package:crypto_mobil/core/data/models/kline_model.dart';
import 'package:crypto_mobil/core/data/models/price_model.dart';
import 'package:crypto_mobil/core/data/models/symbol_model.dart';
import 'package:crypto_mobil/core/data/models/ticker_24h_model.dart';
import 'package:crypto_mobil/core/network/dio_client.dart';
import 'package:crypto_mobil/core/network/socket_client.dart';
import 'package:injectable/injectable.dart';

abstract class MarketRemoteDataSource {
  Future<List<SymbolModel>> getSymbols({
    String? search,
    int limit = 100,
    int offset = 0,
  });

  Future<List<PriceModel>> getPrices();

  Future<PriceModel> getSymbolPrice(String symbol);

  Future<List<KlineModel>> getKlines({
    required String symbol,
    String interval = '1h',
    int limit = 100,
  });

  Future<List<Ticker24hModel>> getTicker24h({List<String>? symbols});

  Stream<PriceModel> subscribeToPriceUpdates(List<String> symbols);

  void unsubscribeFromPriceUpdates(List<String> symbols);
}

@LazySingleton(as: MarketRemoteDataSource)
class MarketRemoteDataSourceImpl implements MarketRemoteDataSource {
  MarketRemoteDataSourceImpl(this._dioClient, this._socketClient);

  final DioClient _dioClient;
  final SocketClient _socketClient;
  final StreamController<PriceModel> _priceStreamController =
      StreamController<PriceModel>.broadcast();

  bool _socketInitialized = false;

  void _ensureSocketInitialized() {
    if (_socketInitialized) return;
    _socketInitialized = true;

    // Connect and setup listeners after connection
    _socketClient.connect(
      onConnected: () {
        _socketClient.on('subscribed', (data) {
          // Handle subscription confirmation
        });

        _socketClient.on('price_update', (data) {
          try {
            final priceModel = PriceModel.fromJson(
              data as Map<String, dynamic>,
            );
            _priceStreamController.add(priceModel);
          } catch (e) {
            // Log error
          }
        });
      },
    );
  }

  @override
  Future<List<SymbolModel>> getSymbols({
    String? search,
    int limit = 100,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit, 'offset': offset};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConfig.marketSymbols,
      queryParameters: queryParams,
    );

    final data = response['data'] as Map<String, dynamic>;
    final symbols = data['symbols'] as List<dynamic>;

    return symbols
        .map((json) => SymbolModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PriceModel>> getPrices() async {
    print('🔵 Fetching prices from: ${ApiConfig.marketPrices}');

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConfig.marketPrices,
    );

    print('🔵 Response received: ${response.keys}');

    final data = response['data'] as Map<String, dynamic>;
    print('🔵 Data keys: ${data.keys}');
    print('🔵 Data source: ${data['source']}');
    print('🔵 Updated at: ${data['updatedAt']}');

    final prices = data['prices'] as List<dynamic>;
    print('🔵 Total prices: ${prices.length}');
    print('🔵 First 3 prices: ${prices.take(3)}');

    final priceModels = prices
        .map((json) => PriceModel.fromJson(json as Map<String, dynamic>))
        .toList();

    print('🔵 Converted to models: ${priceModels.length}');

    return priceModels;
  }

  @override
  Future<PriceModel> getSymbolPrice(String symbol) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '${ApiConfig.marketPrices}/$symbol',
    );

    final data = response['data'] as Map<String, dynamic>;
    return PriceModel.fromJson(data);
  }

  @override
  Future<List<KlineModel>> getKlines({
    required String symbol,
    String interval = '1h',
    int limit = 100,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConfig.marketKlines,
      queryParameters: {'symbol': symbol, 'interval': interval, 'limit': limit},
    );

    final data = response['data'] as Map<String, dynamic>;
    final klines = data['data'] as List<dynamic>;

    return klines
        .map((json) => KlineModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Ticker24hModel>> getTicker24h({List<String>? symbols}) async {
    print('🟡 Fetching ticker24h for: ${symbols?.join(", ") ?? "all"}');

    final queryParams = <String, dynamic>{};

    if (symbols != null && symbols.isNotEmpty) {
      queryParams['symbols'] = symbols.join(',');
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConfig.marketTicker24h,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    print('🟡 Ticker response keys: ${response.keys}');

    final data = response['data'] as Map<String, dynamic>;
    final tickers = data['tickers'] as List<dynamic>;

    print('🟡 Total tickers: ${tickers.length}');
    if (tickers.isNotEmpty) {
      print('🟡 First ticker symbol: ${tickers.first['symbol']}');
    }

    final tickerModels = tickers
        .map((json) => Ticker24hModel.fromJson(json as Map<String, dynamic>))
        .toList();

    print('🟡 Converted to ${tickerModels.length} ticker models');

    return tickerModels;
  }

  @override
  Stream<PriceModel> subscribeToPriceUpdates(List<String> symbols) {
    _ensureSocketInitialized();

    // Subscribe after connection is established
    Future.delayed(const Duration(seconds: 1), () {
      if (_socketClient.isConnected) {
        _socketClient.subscribe(symbols);
      }
    });

    return _priceStreamController.stream;
  }

  @override
  void unsubscribeFromPriceUpdates(List<String> symbols) {
    _socketClient.unsubscribe(symbols);
  }
}
