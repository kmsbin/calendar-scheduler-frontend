sealed class SignInEvent {
  const SignInEvent();
}
final class EmptySignInEvent extends SignInEvent {
  const EmptySignInEvent();
}
final class FailSignInEvent extends SignInEvent {
  const FailSignInEvent();
}
final class SuccessSignInEvent extends SignInEvent {
  const SuccessSignInEvent();
}
final class RequestSignInEvent extends SignInEvent {
  final String email, password;
  const RequestSignInEvent(this.email, this.password);
}

sealed class SignInState {
  const SignInState();
}
final class EmptySignInState extends SignInState {
  const EmptySignInState();
}
final class FailSignInState extends SignInState {
  final String errorMessage;
  const FailSignInState(this.errorMessage);
}
final class SuccessSignInState extends SignInState {
  const SuccessSignInState();
}
final class RequestSignInState extends SignInState {
  const RequestSignInState();
}
