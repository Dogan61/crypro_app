const logger = require('../utils/logger');

/**
 * 404 Not Found handler
 */
const notFoundHandler = (req, res, next) => {
  const error = new Error(`Not Found - ${req.originalUrl}`);
  error.statusCode = 404;
  next(error);
};

/**
 * Merkezi error handler
 */
const errorHandler = (err, req, res, next) => {
  const statusCode = err.statusCode || res.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  // Log error
  logger.error('Request error', {
    statusCode,
    message,
    method: req.method,
    path: req.path,
    stack: err.stack,
    query: req.query,
    body: req.body,
    ip: req.ip,
  });

  // Response
  res.status(statusCode).json({
    error: message,
    ...(process.env.NODE_ENV !== 'production' && { stack: err.stack }),
  });
};

/**
 * Async handler wrapper - route'larda try-catch yazmamak için
 */
const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};

module.exports = {
  notFoundHandler,
  errorHandler,
  asyncHandler,
};
