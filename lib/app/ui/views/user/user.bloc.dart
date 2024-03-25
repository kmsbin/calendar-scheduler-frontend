import 'package:bloc/bloc.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/user_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/user_exception.dart';
import 'package:calendar_scheduler_mobile/app/ui/views/user/user.events.dart';
import 'package:calendar_scheduler_mobile/injector.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final userRepository = getIt.get<UserRepository>();

  UserBloc([super.initialState = const EmptyUserState()]) {
    on(_getUserInfo);
  }

  Future<void> _getUserInfo(GetUserEvent event, Emitter<UserState> emit) async {
    try {
      final user = await userRepository.getUser();
      emit(GetUserState(user));
    } on UserException catch(e) {
      emit(ErrorUserState(e.message));
    } catch(e) {
      emit(const ErrorUserState('Unknown error'));
    }
  }

}