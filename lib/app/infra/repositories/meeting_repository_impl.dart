import 'dart:convert';

import 'package:calendar_scheduler_mobile/app/domain/entities/empty_meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/meeting_range_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../exceptions/meeting.dart';

@Injectable(as: MeetingRepository)
class MeetingRepositoryImpl implements MeetingRepository {
  final Dio dio;

  const MeetingRepositoryImpl(this.dio);

  @override
  Future<String> registerMeetingRange(MeetingRange meetingRange) async {
    try {
      final result = await dio.post<Map<String, dynamic>>(
        '/app/meeting-range',
        data: meetingRange.toJson(),
      );
      if (result.data case {'url': final String url}) return url;

      throw const MeetingException('Something got wrong');
    } catch (e) {
      throw const MeetingException('Something got wrong');
    }
  }

  @override
  Future<MeetingRange?> getMeeting() async {
    try {
      final response = await dio.get<Map<String, dynamic>>('/app/meeting-range');
      final data = response.data;
      if (data == null) return null;
      return MeetingRange.fromJson(data);
    } on DioException catch(e) {
      throw switch(e.response?.statusCode) {
        404 => const MeetingNotFoundedException('Meeting not created'),
        _ => 'Unknown error',
      };
    }

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
    } on DioException catch (e) {
      final errorMessage = switch(e.response?.statusCode) {
        422 => 'Missing parameter in the body',
        409 => e.response?.data['message'] as String? ?? 'Something wents wrong',
        _ => 'Something wents wrong',
      };
      throw MeetingException(errorMessage);
    }
  }
}
