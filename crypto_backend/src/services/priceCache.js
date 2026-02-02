const { createClient } = require('redis');
const logger = require('../utils/logger');

const memoryStore = new Map();
let redisClient = null;
let redisAvailable = false;

const getMemoryValue = (key) => {
  const entry = memoryStore.get(key);
  if (!entry) return null;
  if (entry.expiresAt <= Date.now()) {
    memoryStore.delete(key);
    return null;
  }
  return entry.value;
};

const setMemoryValue = (key, value, ttlSeconds) => {
  memoryStore.set(key, {
    value,
    expiresAt: Date.now() + ttlSeconds * 1000,
  });
};

const initRedis = async (redisUrl) => {
  if (!redisUrl) {
    logger.info('Redis URL not provided, using memory cache');
    return;
  }
  redisClient = createClient({ url: redisUrl });
  redisClient.on('error', (err) => {
    redisAvailable = false;
    logger.error('Redis error', { error: err.message });
  });
  try {
    await redisClient.connect();
    redisAvailable = true;
    logger.info('Redis connected successfully', { url: redisUrl });
  } catch (err) {
    redisAvailable = false;
    logger.warn('Redis connection failed, falling back to memory cache', {
      error: err.message,
    });
  }
};

const getJson = async (key) => {
  if (redisAvailable && redisClient) {
    const raw = await redisClient.get(key);
    return raw ? JSON.parse(raw) : null;
  }
  return getMemoryValue(key);
};

const setJson = async (key, value, ttlSeconds) => {
  if (redisAvailable && redisClient) {
    await redisClient.set(key, JSON.stringify(value), { EX: ttlSeconds });
    return;
  }
  setMemoryValue(key, value, ttlSeconds);
};

const getStatus = () => ({
  redisAvailable,
});

module.exports = {
  initRedis,
  getJson,
  setJson,
  getStatus,
};
