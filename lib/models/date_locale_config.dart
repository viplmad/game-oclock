import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class DateLocaleConfig {
  final int startingDayOfWeek;
  final List<int> weekendDays;
  final DateFormat dateFormat;
  final DateFormat timeFormat;

  DateFormat get dateTimeFormat => dateFormat.addPattern(timeFormat.pattern);

  const DateLocaleConfig({
    required this.startingDayOfWeek,
    required this.weekendDays,
    required this.dateFormat,
    required this.timeFormat,
  });

  DateLocaleConfig.def()
    : this(
        startingDayOfWeek: DateTime.monday,
        weekendDays: [DateTime.saturday, DateTime.sunday],
        dateFormat: DateFormat('d/M/y'),
        timeFormat: DateFormat('HH:mm'),
      );

  DateLocaleConfig copyWith({
    final int? startingDayOfWeek,
    final List<int>? weekendDays,
    final DateFormat? dateFormat,
    final DateFormat? timeFormat,
  }) {
    return DateLocaleConfig(
      startingDayOfWeek: startingDayOfWeek ?? this.startingDayOfWeek,
      weekendDays: weekendDays ?? this.weekendDays,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
    );
  }

  String formatDate(final DateTime date) {
    return dateFormat.format(date);
  }

  String formatTime(final TimeOfDay time) {
    return timeFormat.format(DateTime(2020, 1, 23, time.hour, time.minute));
  }
}
