import 'package:calendar_scheduler_mobile/app/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> registerUser(User user);
  Future<void> sendRequestToResetPassword(String text);
  Future<void> sendResetPassword(String code, String password);
  Future<void> signOut(String token);
}

