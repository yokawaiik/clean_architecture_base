// domain/use_cases/get_order_use_case.dart
import '../entitites/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderUseCase {
  final OrderRepository _repository;

  GetOrderUseCase(this._repository);

  // Вызов Use Case как функции (Паттерн Команда)
  Future<OrderEntity> call(String orderId) async {
    if (orderId.isEmpty) {
      throw const FormatException('Order ID cannot be empty');
    }
    return await _repository.getOrderById(orderId);
  }
}
