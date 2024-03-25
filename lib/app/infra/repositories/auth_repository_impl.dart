import 'package:calendar_scheduler_mobile/app/domain/entities/user.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/auth_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/auth_exception.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final _dio = Dio(BaseOptions(baseUrl: apiUrl));

  @override
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
      400 || 404 => 'Invalid credentials',
      _ => 'Unknown error',
    };
  }

  @override
  Future<void> registerUser(User user) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/sign-up',
        data: user.toJson(),
      );
    } on DioException catch (e) {
      throw AuthException(_errorFromStatusCode(e.response?.statusCode));
    } catch (_) {
      throw AuthException(_errorFromStatusCode());
    }
  }

  @override
  Future<void> sendRequestToResetPassword(String email) async {
    try {
      await _dio.get(
        '/send-password-recover',
        queryParameters: {'email': email},
      );
    } on DioException catch(e) {
      final message = switch(e.response?.statusCode) {
        404 => 'Account not founded!',
        _ => 'Something got wrong!',
      };
      throw AuthException(message);
    } catch(_) {
      throw const AuthException('Something got wrong!');
    }
  }

  @override
  Future<void> sendResetPassword(String code, String password) async {
    try {
      await _dio.post(
        '/receive-password-recover',
        data: {
          'code': code,
          'password': password,
        },
      );
    } on DioException catch(e) {
      final message = switch(e.response?.statusCode) {
        404 => 'Password reset request not found',
        410 => 'The password reset code has expired',
        _ => 'Something got wrong!',
      };
      throw AuthException(message);
    } catch(_) {
      throw const AuthException('Something got wrong!');
    }
  }
}

