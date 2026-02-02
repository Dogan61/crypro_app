const rateLimit = require('express-rate-limit');
const logger = require('../utils/logger');

/**
 * Genel API rate limiter
 */
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 dakika
  max: 100, // 15 dakikada maksimum 100 istek
  message: {
    error: 'Çok fazla istek gönderildi, lütfen daha sonra tekrar deneyin',
  },
  standardHeaders: true, // RateLimit-* header'ları ekle
  legacyHeaders: false, // X-RateLimit-* header'ları devre dışı
  handler: (req, res) => {
    logger.warn('Rate limit exceeded', {
      ip: req.ip,
      path: req.path,
      method: req.method,
    });
    res.status(429).json({
      error: 'Çok fazla istek gönderildi',
      retryAfter: req.rateLimit.resetTime,
    });
  },
});

/**
 * Fiyat endpoint'leri için daha sıkı limiter
 */
const pricesLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 dakika
  max: 30, // 1 dakikada maksimum 30 istek
  message: {
    error: 'Fiyat verisi için çok fazla istek',
  },
  skipSuccessfulRequests: false,
  handler: (req, res) => {
    logger.warn('Prices rate limit exceeded', {
      ip: req.ip,
      path: req.path,
    });
    res.status(429).json({
      error: 'Fiyat verisi için çok fazla istek',
      retryAfter: Math.ceil((req.rateLimit.resetTime - Date.now()) / 1000),
    });
  },
});

/**
 * WebSocket connection rate limiter
 */
const wsLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 dakika
  max: 10, // 1 dakikada maksimum 10 bağlantı
  message: {
    error: 'WebSocket bağlantı limiti aşıldı',
  },
});

module.exports = {
  apiLimiter,
  pricesLimiter,
  wsLimiter,
};
