// data/models/order_dto.dart
import '../../domain/entitites/order_entity.dart';

class OrderDto {
  final String? orderId;
  final List<String>? items;
  final double? amount;
  final String? dateIso;

  const OrderDto({this.orderId, this.items, this.amount, this.dateIso});

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      orderId: json['order_id'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      amount: (json['amount'] as num?)?.toDouble(),
      dateIso: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'items': items,
      'amount': amount,
      'created_at': dateIso,
    };
  }
}
// ? В крупных enterprise проектах такой вариант выносса маппера в extension слишком засоряет контекст
// // Или через расширение
// extension OrderDtoX on OrderDto {
//   OrderEntity toEntity() => OrderEntity(
//     id: orderId ?? 'empty_id_fallback',
//     itemIds: items ?? const [],
//     totalAmount: amount ?? 0.0,
//     createdAt: dateIso != null ? DateTime.parse(dateIso!) : DateTime.now(),
//   );
// }

// extension OrderEntityX on OrderEntity {
//   OrderDto toDto() => OrderDto(
//     orderId: id,
//     items: itemIds,
//     amount: totalAmount,
//     dateIso: createdAt.toIso8601String(),
//   );
// }
