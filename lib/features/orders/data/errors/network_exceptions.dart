class RemoteServerConnectionException implements Exception {
  final int? statusCode;
  final String message;
  RemoteServerConnectionException({this.statusCode, required this.message});
}
