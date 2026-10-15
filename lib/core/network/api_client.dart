import 'dart:io';

import 'package:dio/dio.dart';

import 'package:daily_news/core/error/exceptions.dart';

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data ?? const {};
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.cancel:
        return const RequestCancelledException();
      case DioExceptionType.badResponse:
        final body = e.response?.data;
        return ServerException(
          message: body is Map ? body['message'] as String? : null,
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is SocketException) return const NetworkException();
        return ServerException(message: e.message);
    }
  }
}
