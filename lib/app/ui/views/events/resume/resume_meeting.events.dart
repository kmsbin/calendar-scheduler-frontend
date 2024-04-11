import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';

sealed class ResumeEvent {
  const ResumeEvent();
}
final class GetResumeEvent extends ResumeEvent {
  const GetResumeEvent();
}

sealed class ResumeState {
  const ResumeState();
}
final class EmptyResumeState extends ResumeState {
  const EmptyResumeState();
}
final class LoadingResumeState extends ResumeState {
  const LoadingResumeState();
}
final class FilledResumeState extends ResumeState {
  final MeetingRange range;
  const FilledResumeState(this.range);
}
final class FailedResumeState extends ResumeState {
  final String message;
  const FailedResumeState(this.message);
}
final class FilledWithoutGoogleAccessResumeState extends ResumeState {
  final MeetingRange range;
  final String authUrl;

  const FilledWithoutGoogleAccessResumeState(this.range, this.authUrl);
}
