class MeetingNotFoundedException implements Exception {
  final String message;

  const MeetingNotFoundedException(this.message);
}

class MeetingException implements Exception {
  final String message;

  const MeetingException(this.message);
}