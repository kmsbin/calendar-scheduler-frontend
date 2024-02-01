import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';

sealed class ResumeEvent {}
final class GetResumeEvent extends ResumeEvent {}

sealed class ResumeState {}
final class EmptyResumeState extends ResumeState {}
final class LoadingResumeState extends ResumeState {}
final class FilledResumeState extends ResumeState {
  final MeetingRange range;
  FilledResumeState(this.range);
}
