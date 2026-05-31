// domain/repositories/order_repository.dart
import '../entitites/order_entity.dart';

abstract interface class OrderRepository {
  Future<void> createOrder(OrderEntity order);

  Future<OrderEntity> getOrderById(String orderId);

  Future<List<OrderEntity>> getCachedOrders();
}
