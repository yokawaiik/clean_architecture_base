// data/repositories/network_order_repository_impl.dart
import 'package:dio/dio.dart';

import '../../domain/entitites/order_entity.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../datasources/order_remote_data_source.dart';
import '../mappers/order_mapper.dart';
import '../mappers/order_response_dto_mapper.dart';

class NetworkOrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _localDataSource;
  final OrderRemoteDataSource _remoteDataSource;

  // Поля инициализируются через двоеточие ДО выполнения тела конструктора
  const NetworkOrderRepositoryImpl({
    required this._localDataSource,
    required this._remoteDataSource,
  });

  @override
  Future<void> createOrder(OrderEntity order) async {
    final orderDto = OrderMapper.toDto(order);

    try {
      // Сначала пытаемся отправить через сеть
      await _remoteDataSource.createOrder(orderDto);
    } catch (e) {
      // Если не получилось (например, нет сети), кэшируем локально
      await _localDataSource.cacheOrder(orderDto);
      // И сообщаем доменному слою, что мы ушли в оффлайн
      throw OfflineFailure('Заказ сохранен локально и будет отправлен позже');
    }
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    // Реализуем стратегию: Network-First с кэшированием.
    try {
      // 1. Идем в сеть за свежими данными
      final orderDto = await _remoteDataSource.fetchOrder(orderId);

      // 2. Асинхронно обновляем локальный кэш (не блокируем возврат данных)
      _localDataSource.cacheOrder(orderDto);

      // 3. Возвращаем иммутабельную сущность в Домен
      return OrderMapper.toEntity(orderDto);
    } on DioException catch (e) {
      // Если произошла сетевая ошибка, пытаемся достать из кэша.
      final cachedDto = await _localDataSource.getCachedOrder(orderId);
      if (cachedDto != null) {
        return OrderMapper.toEntity(cachedDto);
      }
      // Если и в кэше ничего нет, транслируем сетевую ошибку на язык домена.
      throw ServerFailure.fromDio(e);
    }
  }

  @override
  Future<List<OrderEntity>> getCachedOrders() =>
      throw UnimplementedError('Сеть не кэширует');
}
