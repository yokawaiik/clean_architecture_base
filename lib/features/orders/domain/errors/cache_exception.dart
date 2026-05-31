class CacheException implements Exception {
  final int? statusCode;
  final String message;
  CacheException({this.statusCode, required this.message});
}
