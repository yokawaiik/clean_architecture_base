import 'package:clean_architecture_base/features/orders/domain/use_cases/get_order_use_case.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/orders/data/repositories/cached_order_repository_proxy.dart';
import '../../features/orders/data/repositories/network_order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/use_cases/create_order_use_case.dart';
import '../../features/orders/presentation/bloc/order_bloc.dart';

final sl = GetIt.instance;

void init() {
  // 1. External / Infrastructure
  sl.registerLazySingleton(
    () => Dio(BaseOptions(baseUrl: 'https://api.store.com')),
  );
  sl.registerLazySingleton(() => LocalDatabase());

  // // 2. Mappers
  // Заменен на extensions
  // sl.registerLazySingleton(() => OrderMapper());

  // 3. Repositories (Инверсия зависимостей)
  // Базовый сетевой репозиторий
  sl.registerLazySingleton<OrderRepository>(
    () => NetworkOrderRepositoryImpl(
      sl<Dio>(),
      dio: null,
      localDataSource: null,
      remoteDataSource: null,
    ),
    instanceName: 'network_repo',
  );

  // Проксирующий репозиторий, который мы отдаем приложению под видом интерфейса OrderRepository
  sl.registerLazySingleton<OrderRepository>(
    () => CachedOrderRepositoryProxy(
      sl<OrderRepository>(instanceName: 'network_repo'),
      sl<LocalDatabase>(),
    ),
  );

  // 4. Use Cases
  sl.registerFactory(() => CreateOrderUseCase(sl<OrderRepository>()));

  // 5. BLoC
  sl.registerFactory(
    () => OrderBloc(
      sl<CreateOrderUseCase>(),
      createOrderUseCase: CreateOrderUseCase(sl<OrderRepository>()),
      getOrderUseCase: GetOrderUseCase(sl<OrderRepository>()),
    ),
  );
}
