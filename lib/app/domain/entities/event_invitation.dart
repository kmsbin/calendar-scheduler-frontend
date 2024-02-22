class EventInvitation {
  final String email;
  final DateTime date;

  const EventInvitation({
    required this.email,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'date': date.toIso8601String(),
    };
  }
}