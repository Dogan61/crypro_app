import 'package:crypto_mobil/core/config/api_config.dart';
import 'package:crypto_mobil/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class DioClient {
  DioClient(this._logger) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger
            ..d('REQUEST[${options.method}] => PATH: ${options.path}')
            ..d('Query: ${options.queryParameters}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger
            ..e(
              'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
            )
            ..e('Message: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }
  late final Dio _dio;
  final Logger _logger;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        final message =
            (responseData is Map<String, dynamic>
                ? responseData['error'] as String?
                : null) ??
            'Unknown error';

        if (statusCode == null) {
          return ServerException(message);
        }

        if (statusCode >= 500) {
          return ServerException(message);
        } else if (statusCode == 429) {
          final retryAfter = responseData is Map<String, dynamic>
              ? responseData['retryAfter'] as int?
              : null;
          return RateLimitException(message, retryAfter);
        } else if (statusCode == 404) {
          return NotFoundException(message);
        } else if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedException(message);
        } else if (statusCode >= 400) {
          return ValidationException(message);
        }
        return ServerException(message);

      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');

      case DioExceptionType.unknown:
        return const NetworkException('No internet connection');

      default:
        return const NetworkException();
    }
  }
}
