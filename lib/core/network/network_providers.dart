import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/config/env.dart';
import 'package:daily_news/core/constants/api_constants.dart';
import 'package:daily_news/core/network/api_client.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'X-Api-Key': Env.newsApiKey},
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestHeader: false, responseBody: false),
    );
  }

  ref.onDispose(dio.close);
  return dio;
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);
