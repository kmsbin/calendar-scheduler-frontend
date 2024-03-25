import 'package:calendar_scheduler_mobile/app/domain/entities/empty_meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/domain/entities/event_invitation.dart';
import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';

abstract interface class MeetingRepository {
  Future<String> registerMeetingRange(MeetingRange meetingRange);
  Future<MeetingRange?> getMeeting();
  Future<List<EmptyMeetingRange>> getEmptyMeetingRange(String code, DateTime date);
  Future<void> sentEventInvitation(String code, EventInvitation invitation);
}