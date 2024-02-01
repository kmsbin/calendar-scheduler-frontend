import 'dart:convert';

import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MeetingRepository)
class MeetingRepositoryImpl implements MeetingRepository {
  final Dio dio;

  const MeetingRepositoryImpl(this.dio);

  @override
  Future<void> registerMeetingRange(MeetingRange meetingRange) async {
    try {
      await dio.post(
        '/app/meeting-range',
        data: meetingRange.toJson(),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<MeetingRange?> getMeeting() async {
    final response = await dio.get<Map<String, dynamic>>('/app/meeting-range');
    final data = response.data;
    if (data == null) return null;
    return MeetingRange.fromJson(data);
  }
}
