import 'package:flutter/material.dart';

class GlobalErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    debugPrint('Global Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getErrorMessage(error)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String _getErrorMessage(dynamic error) {
    if (error is String) return error;
    return 'Something went wrong. Please try again.';
  }
}

abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}

class SearchException extends AppException {
  SearchException(super.message);
}
