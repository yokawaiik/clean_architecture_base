// data/repositories/cached_order_repository_proxy.dart
import '../../domain/entitites/order_entity.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../dtos/order_dto.dart';
import '../mappers/order_mapper.dart';

class CachedOrderRepositoryProxy implements OrderRepository {
  final OrderRepository _networkRepository;
  final OrderLocalDataSource _localDb; // Например, Isar / Hive / Sqflite

  const CachedOrderRepositoryProxy({
    required this._networkRepository,
    required this._localDb,
  });

  @override
  Future<void> createOrder(OrderEntity order) async {
    try {
      // 1. Пытаемся отправить на бэк
      await _networkRepository.createOrder(order);
    } catch (e) {
      // 2. Упала сеть? Пишем в локальную очередь для синхронизации
      final dto = OrderMapper.toDto(order);
      await _localDb.save('offline_orders_box', dto.toJson());
      // Не гасим ошибку, если UI должен знать об оффлайн-режиме
      throw OfflineFailure('Заказ сохранен локально и будет отправлен позже');
    }
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    throw UnimplementedError('Сеть не кэширует');
  }

  @override
  Future<List<OrderEntity>> getCachedOrders() async {
    final rawData =
        await _localDb.getAll('orders_box')
            as List<dynamic>; // Не написана реализиция
    return rawData
        .map((json) => OrderDto.fromJson(json))
        .map((dto) => OrderMapper.toEntity(dto))
        .toList();
  }
}
