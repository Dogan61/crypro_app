import 'dart:convert';

import 'package:crypto_mobil/core/data/datasources/local_storage_datasource.dart';
import 'package:crypto_mobil/core/data/models/price_model.dart';
import 'package:crypto_mobil/core/data/models/ticker_24h_model.dart';
import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:crypto_mobil/core/error/exceptions.dart';
import 'package:injectable/injectable.dart';

abstract class MarketCacheDataSource {
  Future<void> cachePrices(List<PriceEntity> prices);
  Future<List<PriceEntity>?> getCachedPrices();
  
  Future<void> cacheTickers24h(List<Ticker24hEntity> tickers);
  Future<List<Ticker24hEntity>?> getCachedTickers24h();
  
  Future<void> clearCache();
}

const _kPricesCacheKey = 'cached_prices';
const _kTickers24hCacheKey = 'cached_tickers_24h';
const _kCacheTimestampKey = 'cache_timestamp';
const _kCacheMaxAgeHours = 24; // Cache 24 saat geçerli

@LazySingleton(as: MarketCacheDataSource)
class MarketCacheDataSourceImpl implements MarketCacheDataSource {
  MarketCacheDataSourceImpl(this._localStorage);
  final LocalStorageDataSource _localStorage;

  @override
  Future<void> cachePrices(List<PriceEntity> prices) async {
    try {
      final jsonList = prices.map((p) => PriceModel(symbol: p.symbol, price: p.price).toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _localStorage.saveString(_kPricesCacheKey, jsonString);
      await _localStorage.saveString(
        _kCacheTimestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache prices: $e');
    }
  }

  @override
  Future<List<PriceEntity>?> getCachedPrices() async {
    try {
      final jsonString = await _localStorage.getString(_kPricesCacheKey);
      if (jsonString == null) return null;

      // Check cache age
      final timestampStr = await _localStorage.getString(_kCacheTimestampKey);
      if (timestampStr != null) {
        final timestamp = DateTime.parse(timestampStr);
        final age = DateTime.now().difference(timestamp);
        if (age.inHours > _kCacheMaxAgeHours) {
          await clearCache();
          return null;
        }
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => PriceModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached prices: $e');
    }
  }

  @override
  Future<void> cacheTickers24h(List<Ticker24hEntity> tickers) async {
    try {
      final jsonList = tickers.map((t) => Ticker24hModel(
        symbol: t.symbol,
        priceChange: t.priceChange,
        priceChangePercent: t.priceChangePercent,
        weightedAvgPrice: t.weightedAvgPrice,
        prevClosePrice: t.prevClosePrice,
        lastPrice: t.lastPrice,
        lastQty: t.lastQty,
        bidPrice: t.bidPrice,
        askPrice: t.askPrice,
        openPrice: t.openPrice,
        highPrice: t.highPrice,
        lowPrice: t.lowPrice,
        volume: t.volume,
        quoteVolume: t.quoteVolume,
        openTime: t.openTime,
        closeTime: t.closeTime,
        firstId: t.firstId,
        lastId: t.lastId,
        count: t.count,
      ).toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _localStorage.saveString(_kTickers24hCacheKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache tickers: $e');
    }
  }

  @override
  Future<List<Ticker24hEntity>?> getCachedTickers24h() async {
    try {
      final jsonString = await _localStorage.getString(_kTickers24hCacheKey);
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => Ticker24hModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached tickers: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    await _localStorage.delete(_kPricesCacheKey);
    await _localStorage.delete(_kTickers24hCacheKey);
    await _localStorage.delete(_kCacheTimestampKey);
  }
}
