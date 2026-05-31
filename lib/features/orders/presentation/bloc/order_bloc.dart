// presentation/bloc/order_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/errors/cache_exception.dart';
import '../../domain/entitites/order_entity.dart';
import '../../domain/errors/failures.dart';
import '../../domain/use_cases/create_order_use_case.dart';
import '../../domain/use_cases/get_order_use_case.dart';
import 'order_event.dart';
import 'order_state.dart';

// Здесь должно быть кастомное исключение из Data-слоя
class OfflineException implements Exception {
  final String message;
  const OfflineException(this.message);
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase _createOrderUseCase;
  final GetOrderUseCase _getOrderUseCase;

  OrderBloc(
    CreateOrderUseCase createOrderUseCase, {
    required this._createOrderUseCase,
    required this._getOrderUseCase,
  }) : super(OrderInitialState()) {
    on<LoadOrderRequestedEvent>(_onLoadOrder);
  }

  Future<void> _onSubmitOrder(
    SubmitOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoadingState());
    try {
      // Маппим данные из UI-события в чистую доменную сущность Entity
      final order = OrderEntity(
        id: const Uuid().v4(), // Генерация ID — на стыке UI/App слоя
        itemIds: event.items,
        totalAmount: event.total,
        createdAt: DateTime.now(),
      );

      // Передаем управление UseCase
      await _createOrderUseCase(order);

      // Если цепочка выполнилась успешно — заказ на сервере
      emit(OrderSuccessState());
    } on OfflineException catch (e) {
      // Перехватываем инфраструктурную специфику оффлайна
      emit(OrderOfflineSuccessState(message: e.message));
    } catch (e) {
      // Все остальные непредвиденные ошибки
      emit(OrderFailureState(error: e.toString()));
    }
  }

  Future<void> _onLoadOrder(
    LoadOrderRequestedEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoadingState());
    try {
      // Вызываем изолированный доменный сценарий
      final order = await _getOrderUseCase(event.orderId);

      // Передаем чистую доменную сущность в UI
      emit(OrderLoadSuccessState(order));
    } on NetworkFailure catch (f) {
      emit(OrderFailureState(error: f.message));
    } on CacheException catch (e) {
      emit(OrderFailureState(error: e.message));
    } catch (e) {
      emit(const OrderFailureState(error: 'Критическая системная ошибка'));
    }
  }
}
