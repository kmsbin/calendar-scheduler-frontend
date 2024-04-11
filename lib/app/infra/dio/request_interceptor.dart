import 'dart:io';

import 'package:calendar_scheduler_mobile/app/infra/repositories/constants.dart';
import 'package:calendar_scheduler_mobile/router.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      'Access-Control-Allow-Origin': 'https://91natym628.execute-api.us-east-1.amazonaws.com',
    });
    if (!options.path.startsWith('/api')) {
      return super.onRequest(options, handler);
    }
    final prefs = await SharedPreferences.getInstance();
    options.queryParameters['token'] = prefs.getString('token');
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      GoRouter
        .of(router.routerDelegate.navigatorKey.currentContext!)
        .go('/auth/sign-in');
      return;
    }
    super.onError(err, handler);
  }
}