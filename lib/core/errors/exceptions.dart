/// Base exception class
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Database exception
class DatabaseException extends AppException {
  const DatabaseException({required super.message, super.code});
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({required super.message, super.code});
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException({required super.message, super.code});
}

/// Not found exception
class NotFoundException extends AppException {
  const NotFoundException({required super.message, super.code = 'NOT_FOUND'});
}
