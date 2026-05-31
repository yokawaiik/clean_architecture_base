class DioException implements Exception {
  final int? statusCode;
  final String message;
  DioException({this.statusCode, required this.message});
}
