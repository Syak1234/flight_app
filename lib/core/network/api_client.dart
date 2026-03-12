import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../config/app_config.dart';
import '../error/exceptions.dart';

class ApiClient {
  late final Dio _dio;

  // Cache options
  final _cacheOptions = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Caching
    _dio.interceptors.add(DioCacheInterceptor(options: _cacheOptions));

    // Retries
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.data is! Map) {
        throw InvalidResponseException();
      }

      final responseBody = response.data as Map<String, dynamic>;

      if (responseBody['status'] == 'success') {
        if (responseBody.containsKey('data')) {
          return responseBody['data'];
        } else {
          throw InvalidResponseException();
        }
      } else {
        throw ServerException(
          message: responseBody['message'] ?? 'API Error',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is InvalidResponseException || e is ServerException) rethrow;
      throw APIErrorHandler.handleError(e);
    }
  }
}
