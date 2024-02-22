
class EmptyMeetingRange {
  final DateTime startDate;
  final DateTime endDate;

  const EmptyMeetingRange(this.startDate, this.endDate);

  factory EmptyMeetingRange.fromJson(Map<String, String> jsonMap) {
    return EmptyMeetingRange(
      DateTime.parse(jsonMap['start_date']!),
      DateTime.parse(jsonMap['end_date']!),
    );
  }
}