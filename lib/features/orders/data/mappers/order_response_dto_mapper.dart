// Отдельный Маппер (Enterprise-стандарт) для защиты домена от изменений API
import '../../domain/entitites/order_entity.dart';
import '../dtos/order_response_dto.dart';

extension OrderResponseDtoMapper on OrderResponseDto {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      itemIds: itemIds,
      totalAmount: totalAmount,
      // Маппим техническую строку бэкенда на типизированный Enum домена
      createdAt: createdAt,
    );
  }
}
