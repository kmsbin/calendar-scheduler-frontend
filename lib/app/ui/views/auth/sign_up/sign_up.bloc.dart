import 'package:bloc/bloc.dart';
import 'package:calendar_scheduler_mobile/app/domain/entities/user.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/repositories.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/auth_exception.dart';
import 'package:calendar_scheduler_mobile/app/ui/views/auth/sign_up/sign_up.events.dart';
import 'package:calendar_scheduler_mobile/injector.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final _authRepository = getIt.get<AuthRepository>();

  SignUpBloc([super.initialState = const EmptySignUpState()]) {
    on(_sendSignUp);
  }

  Future<void> _sendSignUp(RegisterSignUpEvent event, Emitter<SignUpState> emit) async {
    try {
      await _authRepository.registerUser(
        User(
          name: event.name,
          email: event.email,
          password: event.password,
        )
      );
      await _authRepository.login(event.email, event.password);
      emit(const SuccessSignUpState());
    } on AuthException catch(e) {
      emit(ErrorSignUpState(e.message));
    } catch (e) {
      emit(const ErrorSignUpState('Unknown error'));
    }
  }


}