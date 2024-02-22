import 'dart:convert';

import 'package:calendar_scheduler_mobile/app/domain/entities/empty_meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/meeting_range_exception.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

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

  @override
  Future<List<EmptyMeetingRange>> getEmptyMeetingRange(String code, DateTime date) async {
    final response = await dio.get<List<dynamic>>(
      '/get-events-code',
      queryParameters: {
        'code': code,
        'date': DateFormat('yyyy-MM-dd').format(date),
      },
    );
    final data = response.data;
    if (data == null) throw MeetingRangeException('Something went wrong fetching empty scheduled times');

    return data
      .map((jsonMap) => EmptyMeetingRange.fromJson((jsonMap as Map).cast()))
      .toList();
  }

  @override
  Future<void> sentEventInvitation(code, invitation) async {
    try {
      await dio.post(
        '/event',
        queryParameters: {'code': code},
        data: invitation.toJson(),
      );
    } catch (e) {
      print(e);
    }
  }
}
