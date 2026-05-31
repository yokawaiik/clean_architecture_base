// domain/entities/order_entity.dart

class OrderEntity {
  final String id;
  final List<String> itemIds;
  final double totalAmount;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.itemIds,
    required this.totalAmount,
    required this.createdAt,
  });

  // Бизнес-логика прямо внутри сущности
  bool get isHighValue => totalAmount > 10000;
}
