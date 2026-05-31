// domain/use_cases/create_order_use_case.dart
import '../entitites/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository _repository;

  const CreateOrderUseCase(this._repository);

  Future<void> call(OrderEntity order) async {
    // Валидация бизнес-правила перед отправкой
    if (order.itemIds.isEmpty) {
      throw Exception('Нельзя создать пустой заказ');
    }
    await _repository.createOrder(order);
  }
}
