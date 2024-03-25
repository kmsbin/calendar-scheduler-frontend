sealed class SignUpEvent {
  const SignUpEvent();
}

final class RegisterSignUpEvent extends SignUpEvent {
  final String name;
  final String password;
  final String email;

  const RegisterSignUpEvent({
    required this.name,
    required this.password,
    required this.email,
  });
}

sealed class SignUpState {
  const SignUpState();
}

final class EmptySignUpState extends SignUpState {
  const EmptySignUpState();
}

final class SuccessSignUpState extends SignUpState {
  const SuccessSignUpState();
}

final class ErrorSignUpState extends SignUpState {
  final String message;
  const ErrorSignUpState(this.message);
}
