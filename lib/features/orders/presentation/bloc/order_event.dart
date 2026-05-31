// presentation/bloc/order_event.dart
import 'package:equatable/equatable.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Событие отправки/оформления заказа пользователем
class SubmitOrderEvent extends OrderEvent {
  final List<String> items;
  final double total;

  const SubmitOrderEvent({required this.items, required this.total});

  @override
  List<Object?> get props => [items, total];
}

// НОВОЕ СОБЫТИЕ: Запрос на загрузку данных
class LoadOrderRequestedEvent extends OrderEvent {
  final String orderId;
  const LoadOrderRequestedEvent(this.orderId);
}
