import 'package:flutter/material.dart';

final class DurationConverter {
  static String timeOfDayToString(TimeOfDay time) {
    return '${_padLeft(time.hour)}:${_padLeft(time.minute)}:00';
  }

  static Duration parseStringToDuration(String rawDuration) {
    return Duration(minutes: int.parse(rawDuration.substring(0, rawDuration.length-1)));
  }

  static String _padLeft(int value) => value.toString().padLeft(2, '0');
}