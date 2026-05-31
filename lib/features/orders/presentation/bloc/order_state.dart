// presentation/bloc/order_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entitites/order_entity.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние экрана
class OrderInitialState extends OrderState {}

/// Процесс отправки запроса на бэк/обработки транзакции
class OrderLoadingState extends OrderState {}

/// Заказ успешно обработан и сохранен на бэкенде
class OrderSuccessState extends OrderState {}

/// Заказ успешно сохранен в локальный кэш (оффлайн-режим)
class OrderOfflineSuccessState extends OrderState {
  final String message;

  const OrderOfflineSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Критическая ошибка (сеть, бизнес-валидация и т.д.)
class OrderFailureState extends OrderState {
  final String error;

  const OrderFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

// НОВОЕ СОСТОЯНИЕ: Данные успешно получены
class OrderLoadSuccessState extends OrderState {
  final OrderEntity order;
  const OrderLoadSuccessState(this.order);
}
