import 'package:shared_preferences/shared_preferences.dart';

class AuthUsecase {
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}