import '../dtos/order_dto.dart';

/// Заглушка для локального источника данных, использующая кэш в памяти.
class OrderLocalDataSource {
  // Имитируем кэш с помощью простого Map.
  // Ключ - это ID заказа, значение - DTO заказа.
  final Map<String, OrderDto> _inMemoryCache = {};

  OrderLocalDataSource();

  Future<void> cacheOrder(OrderDto dto) async {
    // Просто добавляем или обновляем запись в нашем кэше.
    _inMemoryCache[dto.orderId!] = dto;
  }

  Future<OrderDto?> getCachedOrder(String id) async {
    // Возвращаем DTO из кэша, если он там есть.
    return _inMemoryCache[id];
  }

  Future<void> save(String s, Map<String, dynamic> json) async {
    throw UnimplementedError();
    /* no-op */
  }

  Future<Object?> getAll(String s) async {
    throw UnimplementedError();
    /* no-op */
  }
}
