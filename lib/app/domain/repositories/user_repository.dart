import 'package:calendar_scheduler_mobile/app/domain/entities/user.dart';

abstract interface class UserRepository {
  Future<User> getUser();
}