// data/models/order_response_dto.dart

class OrderResponseDto {
  final String id;
  final List<String> itemIds;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const OrderResponseDto({
    required this.id,
    required this.itemIds,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderResponseDto(
      id: json['id'] as String,
      itemIds: List<String>.from(json['items'] as List),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: json['created_at'] as DateTime,
    );
  }

  // Сериализация для сохранения входящего ответа в локальный кэш
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': itemIds,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt,
    };
  }
}
