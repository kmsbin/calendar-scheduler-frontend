import 'package:bloc/bloc.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/auth_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/auth_exception.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'sign_in.events.dart';

export 'sign_in.events.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final authRepository = getIt.get<AuthRepository>();
  SignInBloc() : super(EmptySignInState()) {
    on(registrarLogin);
  }

  Future<void> registrarLogin(RequestSignInEvent event, Emitter<SignInState> emit) async {
    try {
      await authRepository.login(event.email, event.password);
      emit(SuccessSignInState());
    } on AuthException catch(e) {
      print('login error $e');
      emit(FailSignInState(e.message));
    } catch (e) {
      print('login error $e');
      emit(FailSignInState('Unknown error'));
    }
  }
}
