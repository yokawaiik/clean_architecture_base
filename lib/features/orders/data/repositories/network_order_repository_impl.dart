// data/repositories/network_order_repository_impl.dart
import 'package:dio/dio.dart';

import '../../domain/entitites/order_entity.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/errors/cache_exception.dart';
import '../datasources/order_local_data_source.dart';
import '../datasources/order_remote_data_source.dart';
import '../errors/dio_exceptions.dart';
import '../mappers/order_mapper.dart';
import '../dtos/order_dto.dart';
import '../mappers/order_response_dto_mapper.dart';

class NetworkOrderRepositoryImpl implements OrderRepository {
  final Dio _dio;
  final OrderLocalDataSource _localDataSource;
  final OrderRemoteDataSource _remoteDataSource;

  // Поля инициализируются через двоеточие ДО выполнения тела конструктора
  const NetworkOrderRepositoryImpl({
    required Dio dio,
    required OrderLocalDataSource localDataSource,
    required OrderRemoteDataSource remoteDataSource,
  }) : _dio = dio,
       _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

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
    // Реализуем стратегию: Network-First с сохранением в кэш. Если сети нет -> читаем кэш.
    if (await _dio.isConnected) {
      try {
        // 1. Идем в сеть за свежими данными
        final orderDto = await _remoteDataSource.fetchOrder(orderId);

        // 2. Асинхронно обновляем локальный кэш
        await _localDataSource.cacheOrder(orderDto);

        // 3. Возвращаем иммутабельную сущность в Домен
        return OrderMapper.toEntity(orderDto);
      } on DioException catch (e) {
        // Трансляция сетевой ошибки на язык бизнеса (Паттерн переводчик)
        throw ServerFailure.fromDio(e);
      }
    } else {
      // Сети нет -> Пытаемся выгрести из локального кэша
      final cachedDto = await _localDataSource.getCachedOrder(orderId);

      if (cachedDto != null) {
        return cachedDto.toEntity();
      }

      // Кэша тоже нет -> Выбрасываем доменную ошибку отсутствия кэша
      throw CacheException(
        message: 'No local data available for this order',
        statusCode: 404,
      );
    }
  }

  @override
  Future<List<OrderEntity>> getCachedOrders() =>
      throw UnimplementedError('Сеть не кэширует');
}
