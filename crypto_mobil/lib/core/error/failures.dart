import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Server failure (5xx errors)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Network failure (no internet, timeout)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Validation failure (400 errors)
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error occurred']);
}

/// Not found failure (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Unauthorized failure (401, 403)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

/// Rate limit failure (429)
class RateLimitFailure extends Failure {
  const RateLimitFailure([
    super.message = 'Rate limit exceeded',
    this.retryAfter,
  ]);
  final int? retryAfter;

  @override
  List<Object?> get props => [message, retryAfter];
}
