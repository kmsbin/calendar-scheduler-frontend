import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';

sealed class RegisterMeetingEvent {
  const RegisterMeetingEvent();
}
final class LoadingMeetingEvent extends RegisterMeetingEvent {
  const LoadingMeetingEvent();
}
final class SendMeetingEvent extends LoadingMeetingEvent {
  final MeetingRange range;
  const SendMeetingEvent(this.range);
}

sealed class RegisterMeetingState {
  const RegisterMeetingState();
}
final class EmptyMeetingState extends RegisterMeetingState {
  const EmptyMeetingState();
}
final class LoadingMeetingState extends RegisterMeetingState {
  const LoadingMeetingState();
}
final class SuccessMeetingState extends RegisterMeetingState {
  const SuccessMeetingState();
}
final class RedirectMeetingState extends RegisterMeetingState {
  final String url;
  const RedirectMeetingState(this.url);
}

final class ErrorMeetingState extends RegisterMeetingState {
  final String message;
  const ErrorMeetingState(this.message);
}
