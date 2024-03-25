import 'package:calendar_scheduler_mobile/app/domain/entities/user.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/user_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/user_exception.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final dio = getIt.get<Dio>();

  @override
  Future<User> getUser() async {
    try {
      final result = await dio.get<Map<String, dynamic>>('/app/user');
      if (result.data case {'email': final String email, 'name': final String name}) {
        return User(
          name: name,
          email: email,
        );
      }
      throw UserException('Error parsing data');
    } catch(e) {
      throw UserException('Unknow error');
    }
  }

}