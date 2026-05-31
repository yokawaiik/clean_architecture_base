import 'package:dio/dio.dart';

import '../dtos/order_dto.dart';

class OrderRemoteDataSource {
  final Dio _dio;
  OrderRemoteDataSource(this._dio);

  Future<OrderDto> fetchOrder(String id) async {
    final response = await _dio.get('/orders/$id');
    return OrderDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> createOrder(OrderDto orderDto) async {
    await _dio.post('/orders', data: orderDto.toJson());
  }
}
