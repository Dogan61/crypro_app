const config = {
  port: process.env.PORT || 3000,
  binanceRestBase: process.env.BINANCE_REST_BASE || 'https://api.binance.com',
  binanceWsBase:
    process.env.BINANCE_WS_BASE || 'wss://stream.binance.com:9443/ws',
  redisUrl: process.env.REDIS_URL || '',
  priceCacheKey: process.env.PRICE_CACHE_KEY || 'binance:prices',
  cacheTtlSeconds: Number(process.env.PRICE_CACHE_TTL || 2),
  enableWsCache: process.env.ENABLE_WS_CACHE !== 'false',
  
  // CORS Configuration
  corsOrigins: process.env.CORS_ORIGINS
    ? process.env.CORS_ORIGINS.split(',')
    : ['http://localhost:3000', 'http://localhost:8080'],
  
  // Node environment
  nodeEnv: process.env.NODE_ENV || 'development',
};

module.exports = config;
