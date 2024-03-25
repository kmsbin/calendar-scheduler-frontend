import 'package:calendar_scheduler_mobile/app/domain/entities/user.dart';

sealed class UserEvent {
  const UserEvent();
}
final class GetUserEvent extends UserEvent {
  const GetUserEvent();
}

sealed class UserState {
  const UserState();
}
final class GetUserState extends UserState {
  final User user;
  const GetUserState(this.user);
}
final class EmptyUserState extends UserState {
  const EmptyUserState();
}
final class ErrorUserState extends UserState {
  final String message;
  const ErrorUserState(this.message);
}