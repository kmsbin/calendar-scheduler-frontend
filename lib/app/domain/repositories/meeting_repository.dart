import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';

abstract interface class MeetingRepository {
  Future<void> registerMeetingRange(MeetingRange meetingRange);

  Future<MeetingRange?> getMeeting();
}