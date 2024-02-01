import 'package:calendar_scheduler_mobile/app/infra/exceptions/auth_exception.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AuthRepository {
  final _dio = Dio(BaseOptions(baseUrl: apiUrl));

  Future<void> login(String email, String password) async {
    try {
      final result = await _dio.get<Map<String, dynamic>>('/sign-in', queryParameters: {
        'email': email,
        'password': password,
      });
      await _setToken(result.data ?? {});
    } on DioException catch (e) {
      throw AuthException(_errorFromStatusCode(e.response?.statusCode));
    } catch (_) {
      throw AuthException(_errorFromStatusCode());
    }
  }
  
  Future<void> _setToken(Map<String, dynamic> jsonMap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', jsonMap['token']);
  }

  String _errorFromStatusCode([int? statusCode]) {
    return switch(statusCode) {
      400 => 'Invalid credentials',
      _ => 'Unknown error',
    };
  }
}

