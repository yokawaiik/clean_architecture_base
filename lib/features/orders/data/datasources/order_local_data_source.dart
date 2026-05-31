import '../dtos/order_dto.dart';
import '../dtos/order_response_dto.dart';

class OrderLocalDataSource {
  final Database _db; // Например, Isar/SQLite
  OrderLocalDataSource(this._db);

  Future<void> cacheOrder(OrderDto dto) async {
    // Сохраняем DTO в локальную таблицу кэша заказов
    await _db.writeTxn(() => _db.orderCache.put(dto));
  }

  Future<OrderResponseDto?> getCachedOrder(String id) async {
    return await _db.orderCache.get(id);
  }
}
