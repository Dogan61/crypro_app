const { Server } = require('socket.io');
const logger = require('../utils/logger');
const config = require('../config');

let io = null;
let connectedClients = 0;

/**
 * Socket.IO sunucusunu başlat
 */
const initSocketServer = (httpServer) => {
  io = new Server(httpServer, {
    cors: {
      origin:
        config.nodeEnv === 'development'
          ? '*'
          : config.corsOrigins,
      credentials: true,
    },
    transports: ['websocket', 'polling'],
  });

  io.on('connection', (socket) => {
    connectedClients++;
    logger.info('Client connected', {
      socketId: socket.id,
      clientsCount: connectedClients,
      remoteAddress: socket.handshake.address,
    });

    // Client'ın abone olmak istediği sembolleri kaydet
    socket.on('subscribe', (symbols) => {
      if (!Array.isArray(symbols)) {
        socket.emit('error', { message: 'Symbols must be an array' });
        return;
      }

      symbols.forEach((symbol) => {
        socket.join(`price:${symbol.toUpperCase()}`);
      });

      logger.info('Client subscribed', {
        socketId: socket.id,
        symbols,
      });

      socket.emit('subscribed', { symbols, count: symbols.length });
    });

    // Abonelikten çık
    socket.on('unsubscribe', (symbols) => {
      if (!Array.isArray(symbols)) {
        socket.emit('error', { message: 'Symbols must be an array' });
        return;
      }

      symbols.forEach((symbol) => {
        socket.leave(`price:${symbol.toUpperCase()}`);
      });

      logger.info('Client unsubscribed', {
        socketId: socket.id,
        symbols,
      });

      socket.emit('unsubscribed', { symbols, count: symbols.length });
    });

    // Ping-pong for connection health
    socket.on('ping', () => {
      socket.emit('pong', { timestamp: Date.now() });
    });

    socket.on('disconnect', (reason) => {
      connectedClients--;
      logger.info('Client disconnected', {
        socketId: socket.id,
        reason,
        clientsCount: connectedClients,
      });
    });

    socket.on('error', (err) => {
      logger.error('Socket error', {
        socketId: socket.id,
        error: err.message,
      });
    });
  });

  logger.info('Socket.IO server initialized');
  return io;
};

/**
 * Fiyat güncellemesini belirli bir sembole abone olan tüm client'lara gönder
 */
const broadcastPriceUpdate = (symbol, priceData) => {
  if (!io) return;

  const room = `price:${symbol.toUpperCase()}`;
  io.to(room).emit('price_update', {
    symbol,
    ...priceData,
    timestamp: Date.now(),
  });
};

/**
 * Tüm fiyatları broadcast et (WebSocket snapshot geldiğinde)
 * OPTIMIZE: Sadece subscribed room'lara gönderir, tüm client'lara spam yapmaz
 */
const broadcastAllPrices = (pricesSnapshot) => {
  if (!io) return;

  let broadcasted = 0;
  let skipped = 0;

  // Her sembol için room kontrolü yap
  pricesSnapshot.prices.forEach((priceData) => {
    const room = `price:${priceData.symbol.toUpperCase()}`;
    const roomSize = io.sockets.adapter.rooms.get(room)?.size || 0;

    // Sadece active subscription varsa broadcast et
    if (roomSize > 0) {
      broadcastPriceUpdate(priceData.symbol, {
        price: priceData.price,
        source: pricesSnapshot.source,
        updatedAt: pricesSnapshot.updatedAt,
      });
      broadcasted++;
    } else {
      skipped++;
    }
  });

  logger.debug('Broadcast prices (room-optimized)', {
    total: pricesSnapshot.prices.length,
    broadcasted,
    skipped,
    source: pricesSnapshot.source,
  });
};

/**
 * Bağlı client sayısını döner
 */
const getConnectedClientsCount = () => connectedClients;

/**
 * Socket.IO instance'ını döner
 */
const getSocketIO = () => io;

module.exports = {
  initSocketServer,
  broadcastPriceUpdate,
  broadcastAllPrices,
  getConnectedClientsCount,
  getSocketIO,
};
