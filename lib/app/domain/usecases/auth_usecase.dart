import 'package:calendar_scheduler_mobile/app/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUsecase {
  final AuthRepository _repository;

  const AuthUsecase(this._repository);

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    await prefs.clear();

    if (token == null || token.isEmpty) return;

    await _repository.signOut(token);
  }
}