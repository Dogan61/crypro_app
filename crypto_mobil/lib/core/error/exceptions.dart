/// Base exception class
class AppException implements Exception {
  const AppException([this.message = 'An error occurred']);
  final String message;

  @override
  String toString() => message;
}

/// Server exception
class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

/// Cache exception
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error occurred']);
}

/// Not found exception
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

/// Unauthorized exception
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

/// Rate limit exception
class RateLimitException extends AppException {
  const RateLimitException([
    super.message = 'Rate limit exceeded',
    this.retryAfter,
  ]);
  final int? retryAfter;
}
