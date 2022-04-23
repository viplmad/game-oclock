import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import 'time_log_recalculation_mode.dart';

class TimeLogAssistantState extends Equatable {
  // ignore: avoid_positional_boolean_parameters
  const TimeLogAssistantState(
    this.date, [
    this.startTime,
    this.endTime,
    this.duration,
    this.recalculationMode = TimeLogRecalculationMode.duration,
  ]);

  final DateTime date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Duration? duration;
  final TimeLogRecalculationMode recalculationMode;

  bool get isValid =>
      startTime != null && duration != null && !duration!.isNegative;

  bool get canRecalculate =>
      startTime != null && endTime != null && duration != null;

  @override
  List<Object> get props => <Object>[
        date,
        startTime ?? TimeOfDay.now(),
        endTime ?? TimeOfDay.now(),
        duration ?? Duration.zero,
        recalculationMode
      ];

  @override
  String toString() => 'TimeLogAssistantState { '
      'date: $date, '
      'startTime: $startTime, '
      'endTime: $endTime, '
      'duration: $duration, '
      'recalculationMode: $recalculationMode'
      ' }';
}
