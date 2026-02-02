const express = require('express');
const router = express.Router();
const config = require('../config');
const logger = require('../utils/logger');
const { pricesLimiter } = require('../middleware/rateLimiter');
const { validate } = require('../middleware/validators');
const { asyncHandler } = require('../middleware/errorHandler');
const {
  fetchExchangeInfo,
  fetchAllPrices,
  fetchSymbolPrice,
  fetchKlines,
  fetch24hTicker,
} = require('../services/binanceRest');
const { getJson, setJson } = require('../services/priceCache');
const { getLatestSnapshot } = require('../services/binanceStream');

/**
 * GET /api/market/symbols
 * Tüm USDT trading çiftlerini döner (cache'den veya Binance'den)
 */
router.get('/symbols', validate('symbolsQuery', 'query'), asyncHandler(async (req, res) => {
  const { search, limit, offset } = req.query;
  const cacheKey = 'symbols:spot:usdt';
  
  let cached = await getJson(cacheKey);
  
  if (!cached) {
    const symbolsData = await fetchExchangeInfo();
    await setJson(cacheKey, symbolsData, 3600); // 1 saat cache
    cached = symbolsData;
  }

  let symbols = cached.symbols || [];

  // Search filter
  if (search) {
    const searchUpper = search.toUpperCase();
    symbols = symbols.filter(
      (s) =>
        s.symbol.includes(searchUpper) ||
        s.baseAsset.includes(searchUpper)
    );
  }

  // Pagination
  const total = symbols.length;
  const paginatedSymbols = symbols.slice(offset, offset + limit);

  return res.json({
    data: {
      symbols: paginatedSymbols,
      count: paginatedSymbols.length,
      total,
      limit,
      offset,
      fetchedAt: cached.fetchedAt,
    },
    cache: cached === await getJson(cacheKey) ? 'hit' : 'miss',
  });
}));

/**
 * GET /api/market/prices
 * Tüm fiyatları döner (cache'den, WebSocket snapshot'tan veya REST'ten)
 */
router.get('/prices', pricesLimiter, asyncHandler(async (req, res) => {
  const cacheKey = config.priceCacheKey;
  const cached = await getJson(cacheKey);
  
  if (cached) {
    return res.json({
      data: cached,
      cache: 'hit',
    });
  }

  // WebSocket snapshot varsa onu kullan
  const streamSnapshot = getLatestSnapshot();
  if (streamSnapshot) {
    await setJson(cacheKey, streamSnapshot, config.cacheTtlSeconds);
    return res.json({
      data: streamSnapshot,
      cache: 'miss',
      source: 'websocket',
    });
  }

  // Yoksa REST'ten çek
  const restSnapshot = await fetchAllPrices();
  await setJson(cacheKey, restSnapshot, config.cacheTtlSeconds);
  
  return res.json({
    data: restSnapshot,
    cache: 'miss',
    source: 'rest',
  });
}));

/**
 * GET /api/market/prices/:symbol
 * Tek bir sembolün fiyatını döner
 */
router.get(
  '/prices/:symbol',
  pricesLimiter,
  validate('symbol', 'params'),
  asyncHandler(async (req, res) => {
    const { symbol } = req.params;
    const symbolUpper = symbol.toUpperCase();
    
    // Önce genel price cache'e bak
    const allPrices = await getJson(config.priceCacheKey);
    if (allPrices && allPrices.prices) {
      const found = allPrices.prices.find((p) => p.symbol === symbolUpper);
      if (found) {
        return res.json({
          data: {
            symbol: found.symbol,
            price: found.price,
            updatedAt: allPrices.updatedAt,
            source: allPrices.source,
          },
          cache: 'hit',
        });
      }
    }

    // Cache'de yoksa Binance'den direkt çek
    const priceData = await fetchSymbolPrice(symbolUpper);
    
    return res.json({
      data: priceData,
      cache: 'miss',
    });
  })
);

/**
 * GET /api/market/klines
 * Historical candlestick data (grafik için)
 * Query params: symbol, interval, limit
 */
router.get(
  '/klines',
  validate('klinesQuery', 'query'),
  asyncHandler(async (req, res) => {
    const { symbol, interval, limit } = req.query;
    const symbolUpper = symbol.toUpperCase();

    // Cache anahtarı: klines:BTCUSDT:1h
    const cacheKey = `klines:${symbolUpper}:${interval}`;
    const cached = await getJson(cacheKey);

    if (cached && cached.count === limit) {
      return res.json({
        data: cached,
        cache: 'hit',
      });
    }

    // Binance'den çek
    const klinesData = await fetchKlines(symbolUpper, interval, limit);
    
    // 1 dakika cache (klines verisi sık değişir)
    await setJson(cacheKey, klinesData, 60);

    return res.json({
      data: klinesData,
      cache: 'miss',
    });
  })
);

/**
 * GET /api/market/ticker/24h
 * 24 saat ticker istatistikleri (fiyat değişimi %, hacim, high, low)
 * Query params: symbols (virgülle ayrılmış, opsiyonel - boşsa tüm USDT çiftleri)
 */
router.get(
  '/ticker/24h',
  validate('ticker24hQuery', 'query'),
  asyncHandler(async (req, res) => {
    const { symbols } = req.query;

    if (!symbols) {
      // Tüm USDT çiftleri için ticker
      const cacheKey = 'ticker:24h:all';
      const cached = await getJson(cacheKey);

      if (cached) {
        return res.json({
          data: cached,
          cache: 'hit',
        });
      }

      // Binance'den tüm tickerları çek
      const allTickers = await fetch24hTicker();
      
      // Sadece USDT çiftlerini filtrele
      const usdtTickers = {
        tickers: allTickers.tickers.filter((t) =>
          t.symbol.endsWith('USDT')
        ),
        count: 0,
        fetchedAt: allTickers.fetchedAt,
      };
      usdtTickers.count = usdtTickers.tickers.length;

      // 5 dakika cache (24h stats sık değişmez)
      await setJson(cacheKey, usdtTickers, 300);

      return res.json({
        data: usdtTickers,
        cache: 'miss',
      });
    }

    // Belirli semboller için
    const symbolArray = Array.isArray(symbols) ? symbols : [symbols];
    const results = await Promise.all(
      symbolArray.map(async (symbol) => {
        const cacheKey = `ticker:24h:${symbol}`;
        const cached = await getJson(cacheKey);

        if (cached) {
          return cached.ticker;
        }

        const tickerData = await fetch24hTicker(symbol);
        await setJson(cacheKey, tickerData, 300); // 5 dakika cache

        return tickerData.ticker;
      })
    );

    return res.json({
      data: {
        tickers: results,
        count: results.length,
        fetchedAt: Date.now(),
      },
      cache: 'partial',
    });
  })
);

module.exports = router;
