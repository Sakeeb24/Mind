/// Base exception class for all MindSpace errors.
sealed class AppException implements Exception {
  const AppException(this.message, {this.stackTrace});

  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message';
}

/// Authentication errors
class AuthException extends AppException {
  const AuthException(super.message, {super.stackTrace});
}

/// Network / API errors
class NetworkException extends AppException {
  const NetworkException(super.message, {super.stackTrace});
}

/// Local storage errors
class StorageException extends AppException {
  const StorageException(super.message, {super.stackTrace});
}

/// PDF processing errors
class PdfException extends AppException {
  const PdfException(super.message, {super.stackTrace});
}

/// AI service errors
class AiException extends AppException {
  const AiException(super.message, {super.stackTrace});
}

/// Rate limit exceeded
class RateLimitException extends AiException {
  const RateLimitException(super.message, {super.stackTrace});
}

/// General validation errors
class ValidationException extends AppException {
  const ValidationException(super.message, {super.stackTrace});
}
