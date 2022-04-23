import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  static const TimeOfDay startOfDay = TimeOfDay(hour: 0, minute: 0);

  bool isAfter(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute > other.minute);
  }

  bool isPrevious(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }

  TimeOfDay add(Duration duration) {
    DateTime dateTime = _asDateTime();
    dateTime = dateTime.add(duration);

    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  }

  TimeOfDay subtract(Duration duration) {
    DateTime dateTime = _asDateTime();
    dateTime = dateTime.subtract(duration);

    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  }

  Duration difference(TimeOfDay other) {
    final DateTime dateTime = _asDateTime();
    final DateTime otherDateTime = other._asDateTime();

    return dateTime.difference(otherDateTime);
  }

  DateTime _asDateTime() {
    return DateTime(DateTime.now().year, 1, 1, hour, minute);
  }
}
