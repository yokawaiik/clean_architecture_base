// data/mappers/order_mapper.dart
import '../../domain/entitites/order_entity.dart';
import '../dtos/order_dto.dart';

abstract class OrderMapper {
  static OrderEntity toEntity(OrderDto dto) {
    return OrderEntity(
      id: dto.orderId ?? 'empty_id_fallback',
      itemIds: dto.items ?? const [],
      totalAmount: dto.amount ?? 0.0,
      createdAt: dto.dateIso != null
          ? DateTime.parse(dto.dateIso!)
          : DateTime.now(),
    );
  }

  static OrderDto toDto(OrderEntity entity) {
    return OrderDto(
      orderId: entity.id,
      items: entity.itemIds,
      amount: entity.totalAmount,
      dateIso: entity.createdAt.toIso8601String(),
    );
  }
}
