import 'package:calendar_scheduler_mobile/app/domain/entities/empty_meeting_range.dart';

abstract class GuestSchedulerState {}
final class GuestSchedulerEmptyState extends GuestSchedulerState {}
final class GuestSchedulerLoadingState extends GuestSchedulerState {}
final class GuestSchedulerErrorState extends GuestSchedulerState {
  final String message;
  GuestSchedulerErrorState(this.message);
}
final class GuestSchedulerSuccessGetListState extends GuestSchedulerState {
  final List<EmptyMeetingRange> itens;
  final DateTime currentDate;
  GuestSchedulerSuccessGetListState(this.itens, this.currentDate);
}
final class GuestSchedulerSuccessCreateInvitationState extends GuestSchedulerState {}

abstract class GuestSchedulerEvent {}
final class GuestSchedulerRequestMeetingsEvent extends GuestSchedulerEvent {
  final String code;
  final DateTime date;
  GuestSchedulerRequestMeetingsEvent(this.code, this.date);
}

final class GuestSchedulerRequestScheduleEvent extends GuestSchedulerEvent {
  final String code;
  final String email;
  final EmptyMeetingRange data;
  
  GuestSchedulerRequestScheduleEvent({
    required this.code, 
    required this.email, 
    required this.data,
  });
}

