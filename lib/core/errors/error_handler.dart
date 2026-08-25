import 'package:flutter/foundation.dart';

import 'app_exception.dart';

/// Handles errors globally and converts them to user-friendly messages.
class ErrorHandler {
  const ErrorHandler._();

  static String getUserMessage(Object error) {
    return switch (error) {
      AppException(:final message) => message,
      _ => 'An unexpected error occurred. Please try again.',
    };
  }

  static void log(Object error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack: $stackTrace');
      }
    }
    // In production, send to crash reporting service.
  }
}
