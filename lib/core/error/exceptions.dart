import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  @override
  String toString() => 'No Internet Connection. Please check your network.';
}

class TimeoutException implements Exception {
  @override
  String toString() => 'The connection has timed out. Please try again.';
}

class InvalidResponseException implements Exception {
  @override
  String toString() => 'Received an invalid response from the server.';
}

class APIErrorHandler {
  static dynamic handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return TimeoutException();
        case DioExceptionType.badResponse:
          final responseData = error.response?.data;
          String errorMsg = 'An error occurred';
          if (responseData != null && responseData is Map) {
            errorMsg = responseData['message'] ?? responseData['error'] ?? 'Server Error';
          }
          return ServerException(
            message: errorMsg,
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.cancel:
          return ServerException(message: 'Request was cancelled');
        case DioExceptionType.connectionError:
          return NetworkException();
        default:
          return ServerException(message: 'Unexpected network error');
      }
    }
    return ServerException(message: error.toString());
  }
}
