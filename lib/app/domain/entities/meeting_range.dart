import 'package:intl/intl.dart';
import 'package:calendar_scheduler_mobile/app/infra/converters/duration_converter.dart';
import 'package:flutter/material.dart';

class MeetingRange {
  final int id;
  final String summary;
  final Duration duration;
  final TimeOfDay start;
  final TimeOfDay end;
  final String code;
  final String? authUrl;

  const MeetingRange({
    this.id = 0,
    required this.summary,
    required this.duration,
    required this.start,
    required this.end,
    this.code = '',
    this.authUrl,
  });

  factory MeetingRange.fromJson(Map<String, dynamic> data) {

    return MeetingRange(
      id: data['id'] as int? ?? 0,
      summary: data['summary'] as String,
      duration: DurationConverter.parseStringToDuration((data['duration'] as String)),
      start: TimeOfDay.fromDateTime(DateTime.parse(data['start'] as String)),
      end: TimeOfDay.fromDateTime(DateTime.parse(data['end'] as String)),
      code: data['code'] as String,
      authUrl: data['auth_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'duration': '${duration.inMinutes}m',
      'start': DurationConverter.timeOfDayToString(start),
      'end': DurationConverter.timeOfDayToString(end),
      if (authUrl != null)
        'auth_url': authUrl,
    };
  }

  @override
  String toString() {
    return 'MeetingRange(summary: $summary, duration: $duration, start: $duration, end: $end)';
  }
}
