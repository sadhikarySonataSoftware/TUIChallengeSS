import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/api_config.dart';
import '../logging/app_logger.dart';
import 'verbose_dio_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 12),
      sendTimeout: const Duration(seconds: 8),
      headers: const {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(const VerboseDioInterceptor());

  AppLogger.info('Dio configured with baseUrl=${ApiConfig.baseUrl}', tag: 'HTTP');
  return dio;
});
