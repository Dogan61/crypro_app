const Joi = require('joi');
const logger = require('../utils/logger');

/**
 * Symbol validation pattern (Binance format: BTCUSDT)
 */
const symbolPattern = /^[A-Z0-9]{6,12}$/;

/**
 * Validation schemas
 */
const schemas = {
  symbol: Joi.object({
    symbol: Joi.string()
      .pattern(symbolPattern)
      .uppercase()
      .required()
      .messages({
        'string.pattern.base': 'Sembol formatı geçersiz (örn: BTCUSDT)',
        'any.required': 'Sembol parametresi gerekli',
      }),
  }),

  symbolsQuery: Joi.object({
    search: Joi.string().min(1).max(20).optional(),
    limit: Joi.number().integer().min(1).max(1000).default(100).optional(),
    offset: Joi.number().integer().min(0).default(0).optional(),
  }),

  klinesQuery: Joi.object({
    symbol: Joi.string()
      .pattern(symbolPattern)
      .uppercase()
      .required()
      .messages({
        'string.pattern.base': 'Sembol formatı geçersiz',
      }),
    interval: Joi.string()
      .valid(
        '1m',
        '3m',
        '5m',
        '15m',
        '30m',
        '1h',
        '2h',
        '4h',
        '6h',
        '8h',
        '12h',
        '1d',
        '3d',
        '1w',
        '1M'
      )
      .default('1h')
      .messages({
        'any.only': 'Geçersiz interval (örn: 1m, 1h, 1d)',
      }),
    limit: Joi.number().integer().min(1).max(1000).default(100).optional(),
  }),

  ticker24hQuery: Joi.object({
    symbols: Joi.string()
      .optional()
      .custom((value, helpers) => {
        const symbols = value.split(',').map((s) => s.trim().toUpperCase());
        const invalidSymbols = symbols.filter(
          (s) => !symbolPattern.test(s)
        );
        if (invalidSymbols.length > 0) {
          return helpers.error('string.pattern.base', {
            symbols: invalidSymbols.join(', '),
          });
        }
        return symbols;
      })
      .messages({
        'string.pattern.base': 'Geçersiz sembol formatı: {{symbols}}',
      }),
  }),
};

/**
 * Validation middleware factory
 */
const validate = (schemaName, source = 'params') => {
  return (req, res, next) => {
    const schema = schemas[schemaName];
    if (!schema) {
      logger.error('Validation schema not found', { schemaName });
      return res.status(500).json({ error: 'Internal validation error' });
    }

    const { error, value } = schema.validate(req[source], {
      abortEarly: false,
      stripUnknown: true,
    });

    if (error) {
      const errors = error.details.map((detail) => ({
        field: detail.path.join('.'),
        message: detail.message,
      }));

      logger.warn('Validation error', {
        source,
        errors,
        received: req[source],
      });

      return res.status(400).json({
        error: 'Validation failed',
        details: errors,
      });
    }

    // Validated değerleri req'e yerleştir
    req[source] = value;
    next();
  };
};

module.exports = {
  validate,
  schemas,
};
