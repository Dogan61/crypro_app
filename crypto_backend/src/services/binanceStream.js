const WebSocket = require('ws');
const config = require('../config');
const logger = require('../utils/logger');

let ws = null;
let lastMessageAt = 0;
let lastSnapshot = null;
let reconnectTimer = null;

const connect = (onSnapshot) => {
  const url = `${config.binanceWsBase}/!miniTicker@arr`;
  ws = new WebSocket(url);

  ws.on('open', () => {
    logger.info('Binance WebSocket connected', { url });
  });

  ws.on('message', (raw) => {
    try {
      const payload = JSON.parse(raw.toString());
      const now = Date.now();
      lastMessageAt = now;
      lastSnapshot = {
        source: 'ws',
        updatedAt: now,
        prices: payload.map((item) => ({
          symbol: item.s,
          price: item.c,
        })),
      };
      if (onSnapshot) onSnapshot(lastSnapshot);
    } catch (err) {
      logger.warn('Binance WebSocket parse error', { error: err.message });
    }
  });

  ws.on('close', () => {
    logger.warn('Binance WebSocket disconnected, scheduling reconnect');
    scheduleReconnect(onSnapshot);
  });

  ws.on('error', (err) => {
    logger.error('Binance WebSocket error', { error: err.message });
    try {
      ws.close();
    } catch (closeErr) {
      logger.error('WebSocket close error', { error: closeErr.message });
    }
  });
};

const scheduleReconnect = (onSnapshot) => {
  if (reconnectTimer) return;
  reconnectTimer = setTimeout(() => {
    reconnectTimer = null;
    connect(onSnapshot);
  }, 3000);
};

const startPriceStream = (onSnapshot) => {
  if (ws) return;
  connect(onSnapshot);
};

const getStreamStatus = () => ({
  connected: ws ? ws.readyState === WebSocket.OPEN : false,
  lastMessageAt,
});

const getLatestSnapshot = () => lastSnapshot;

module.exports = {
  startPriceStream,
  getStreamStatus,
  getLatestSnapshot,
};
