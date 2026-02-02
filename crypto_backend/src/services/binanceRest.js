const config = require('../config');

/**
 * Binance'den tüm trading sembolleri bilgisini çeker
 * USDT çiftlerini filtreler
 */
const fetchExchangeInfo = async () => {
  const response = await fetch(`${config.binanceRestBase}/api/v3/exchangeInfo`);
  if (!response.ok) {
    throw new Error(`Binance exchangeInfo error: ${response.status}`);
  }
  const data = await response.json();
  
  // Sadece TRADING durumunda olan ve USDT çiftleri olan sembolleri filtrele
  const usdtSymbols = data.symbols
    .filter((s) => s.status === 'TRADING' && s.quoteAsset === 'USDT')
    .map((s) => ({
      symbol: s.symbol,
      baseAsset: s.baseAsset,
      quoteAsset: s.quoteAsset,
      status: s.status,
    }));

  return {
    symbols: usdtSymbols,
    count: usdtSymbols.length,
    fetchedAt: Date.now(),
  };
};

/**
 * Tüm fiyatları çeker
 */
const fetchAllPrices = async () => {
  const response = await fetch(`${config.binanceRestBase}/api/v3/ticker/price`);
  if (!response.ok) {
    throw new Error(`Binance REST error: ${response.status}`);
  }
  const data = await response.json();
  const now = Date.now();
  return {
    source: 'rest',
    updatedAt: now,
    prices: data.map((item) => ({
      symbol: item.symbol,
      price: item.price,
    })),
  };
};

/**
 * Tek bir sembolün fiyatını çeker
 */
const fetchSymbolPrice = async (symbol) => {
  const response = await fetch(
    `${config.binanceRestBase}/api/v3/ticker/price?symbol=${symbol}`
  );
  if (!response.ok) {
    throw new Error(`Binance symbol price error: ${response.status}`);
  }
  const data = await response.json();
  return {
    symbol: data.symbol,
    price: data.price,
    fetchedAt: Date.now(),
  };
};

/**
 * Klines (mum grafiği) verilerini çeker
 * @param {string} symbol - Trading pair (örn: BTCUSDT)
 * @param {string} interval - Zaman aralığı (1m, 1h, 1d vb.)
 * @param {number} limit - Kaç mum çekilecek (maks 1000)
 */
const fetchKlines = async (symbol, interval = '1h', limit = 100) => {
  const url = new URL(`${config.binanceRestBase}/api/v3/klines`);
  url.searchParams.append('symbol', symbol);
  url.searchParams.append('interval', interval);
  url.searchParams.append('limit', limit);

  const response = await fetch(url.toString());
  if (!response.ok) {
    throw new Error(`Binance klines error: ${response.status}`);
  }

  const data = await response.json();

  // Binance formatını daha kullanışlı formata çevir
  const formattedData = data.map((candle) => ({
    openTime: candle[0],
    open: parseFloat(candle[1]),
    high: parseFloat(candle[2]),
    low: parseFloat(candle[3]),
    close: parseFloat(candle[4]),
    volume: parseFloat(candle[5]),
    closeTime: candle[6],
    quoteVolume: parseFloat(candle[7]),
    trades: candle[8],
  }));

  return {
    symbol,
    interval,
    data: formattedData,
    count: formattedData.length,
    fetchedAt: Date.now(),
  };
};

/**
 * 24 saat ticker istatistikleri (fiyat değişimi, hacim vb.)
 * @param {string} symbol - Trading pair (örn: BTCUSDT) - opsiyonel, boşsa tüm semboller
 */
const fetch24hTicker = async (symbol = null) => {
  const url = new URL(`${config.binanceRestBase}/api/v3/ticker/24hr`);
  if (symbol) {
    url.searchParams.append('symbol', symbol);
  }

  const response = await fetch(url.toString());
  if (!response.ok) {
    throw new Error(`Binance 24h ticker error: ${response.status}`);
  }

  const data = await response.json();

  // Tek sembol vs array formatı
  const formatTicker = (ticker) => ({
    symbol: ticker.symbol,
    priceChange: parseFloat(ticker.priceChange),
    priceChangePercent: parseFloat(ticker.priceChangePercent),
    weightedAvgPrice: parseFloat(ticker.weightedAvgPrice),
    prevClosePrice: parseFloat(ticker.prevClosePrice),
    lastPrice: parseFloat(ticker.lastPrice),
    lastQty: parseFloat(ticker.lastQty),
    bidPrice: parseFloat(ticker.bidPrice),
    askPrice: parseFloat(ticker.askPrice),
    openPrice: parseFloat(ticker.openPrice),
    highPrice: parseFloat(ticker.highPrice),
    lowPrice: parseFloat(ticker.lowPrice),
    volume: parseFloat(ticker.volume),
    quoteVolume: parseFloat(ticker.quoteVolume),
    openTime: ticker.openTime,
    closeTime: ticker.closeTime,
    firstId: ticker.firstId,
    lastId: ticker.lastId,
    count: ticker.count,
  });

  if (Array.isArray(data)) {
    return {
      tickers: data.map(formatTicker),
      count: data.length,
      fetchedAt: Date.now(),
    };
  }

  return {
    ticker: formatTicker(data),
    fetchedAt: Date.now(),
  };
};

module.exports = {
  fetchExchangeInfo,
  fetchAllPrices,
  fetchSymbolPrice,
  fetchKlines,
  fetch24hTicker,
};
