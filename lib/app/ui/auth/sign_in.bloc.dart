import 'package:bloc/bloc.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/auth_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/auth_exception.dart';
import 'package:calendar_scheduler_mobile/injector.dart';

sealed class SignInEvent {}
final class EmptySignInEvent extends SignInEvent {}
final class FailSignInEvent extends SignInEvent {}
final class SuccessSignInEvent extends SignInEvent {}
final class RequestSignInEvent extends SignInEvent {
  final String email, password;
  RequestSignInEvent(this.email, this.password);
}

sealed class SignInState {}
final class EmptySignInState extends SignInState {}
final class FailSignInState extends SignInState {
  final String errorMessage;
  FailSignInState(this.errorMessage);
}
final class SuccessSignInState extends SignInState {}
final class RequestSignInState extends SignInState {}

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
      emit(FailSignInState(e.message));
    } catch (e) {
      emit(FailSignInState('Unknown error'));
    }
  }
}
