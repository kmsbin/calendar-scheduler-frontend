import 'package:calendar_scheduler_mobile/app/infra/repositories/constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'debug_interceptor.dart';
import 'request_interceptor.dart';

final dioOptions = BaseOptions(
  connectTimeout: const Duration(milliseconds: 30000),
  receiveTimeout: const Duration(milliseconds: 30000),
  baseUrl: apiUrl,
);

@module
abstract class DioProvider {
  @singleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        baseUrl: apiUrl,
      ),
    );
    dio.interceptors.addAll([
      RequestInterceptor(),
      DebugLogInterceptor(),
    ]);
    return dio;
  }
}

