const express = require('express');
const http = require('http');
const cors = require('cors');
const config = require('./config');
const logger = require('./utils/logger');
const { apiLimiter } = require('./middleware/rateLimiter');
const {
  notFoundHandler,
  errorHandler,
} = require('./middleware/errorHandler');
const {
  initRedis,
  setJson,
  getStatus: getCacheStatus,
} = require('./services/priceCache');
const {
  startPriceStream,
  getStreamStatus,
} = require('./services/binanceStream');
const {
  initSocketServer,
  broadcastAllPrices,
  getConnectedClientsCount,
} = require('./services/socketServer');
const marketRoutes = require('./routes/market');

const app = express();
const httpServer = http.createServer(app);

// CORS Configuration
const corsOptions = {
  origin: (origin, callback) => {
    // Development ortamında tüm originlere izin ver
    if (config.nodeEnv === 'development') {
      callback(null, true);
    } else if (!origin || config.corsOrigins.includes(origin)) {
      callback(null, true);
    } else {
      logger.warn('CORS blocked', { origin });
      callback(new Error('CORS policy violation'));
    }
  },
  credentials: true,
};

app.use(cors(corsOptions));
app.use(express.json());

// Rate limiting
app.use('/api/', apiLimiter);

// Sağlık kontrolü
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'crypto_backend',
    cache: getCacheStatus(),
    binanceStream: getStreamStatus(),
    socketIO: {
      connectedClients: getConnectedClientsCount(),
    },
  });
});

// Market route'larını bağla
app.use('/api/market', marketRoutes);

// Error handling middleware (en sonda olmalı)
app.use(notFoundHandler);
app.use(errorHandler);

const start = async () => {
  // Redis bağlantısı
  await initRedis(config.redisUrl);

  // Socket.IO sunucusu
  initSocketServer(httpServer);

  // Binance WebSocket stream
  logger.info('WebSocket cache enabled', { enableWsCache: config.enableWsCache });
  
  if (config.enableWsCache) {
    startPriceStream((snapshot) => {
      logger.debug('Binance snapshot received', {
        symbolCount: snapshot.prices.length,
        source: snapshot.source,
      });

      // Redis'e yaz
      setJson(config.priceCacheKey, snapshot, config.cacheTtlSeconds).catch(
        (err) => {
          logger.error('Cache write failed', { error: err.message });
        }
      );

      // Socket.IO üzerinden client'lara push et
      broadcastAllPrices(snapshot);
    });
  } else {
    logger.warn('WebSocket cache is DISABLED - price updates will not be broadcasted!');
  }

  // HTTP server'ı başlat
  httpServer.listen(config.port, () => {
    logger.info('Server started', {
      port: config.port,
      url: `http://localhost:${config.port}`,
      socketIO: 'enabled',
      websocket: config.enableWsCache ? 'enabled' : 'disabled',
    });
  });
};

start();
