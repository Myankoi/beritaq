/// BASE EXCEPTION
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// SERVER / API ERROR
class ServerException extends AppException {
  ServerException(super.message);
}

/// CACHE / LOCAL STORAGE ERROR
class CacheException extends AppException {
  CacheException(super.message);
}

/// NETWORK ERROR (no internet, timeout, dll)
class NetworkException extends AppException {
  NetworkException(super.message);
}
