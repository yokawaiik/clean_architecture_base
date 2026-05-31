import '../../data/errors/dio_exceptions.dart';

sealed class Failure {}

class NetworkFailure extends Failure {
  final String message;
  NetworkFailure(this.message);
} // Вот он! Бизнес-класс отсутствия сети.

class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);

  ServerFailure.fromDio(DioException dioException)
    : message = dioException.message,
      super();
}

class OfflineFailure extends Failure {
  final String message;
  OfflineFailure(this.message);
}
