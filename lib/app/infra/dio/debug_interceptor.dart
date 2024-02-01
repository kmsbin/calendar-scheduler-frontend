import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DebugLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {

      String data = '';
      if (options.data?.isNotEmpty ?? false) {
        data = 'data: ${json.encode(options.data)}';
      }
      final params = options.queryParameters.keys.map((param) {
        return '$param=${options.queryParameters[param]}';
      }).join('&');

      final paramConcat = options.path.contains('?')  ? '&' : '?';
      developer.log('${options.baseUrl}${options.path}$paramConcat$params $data',
        name: 'Request ${options.method}',
      );
    }

    handler.next(options);
  }
}