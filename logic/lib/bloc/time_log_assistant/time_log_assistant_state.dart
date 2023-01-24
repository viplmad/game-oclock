import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import 'package:logic/model/model.dart' show GameLogRecalculationMode;

class GameLogAssistantState extends Equatable {
  // ignore: avoid_positional_boolean_parameters
  const GameLogAssistantState(
    this.date, [
    this.startTime,
    this.endTime,
    this.duration,
    this.recalculationMode = GameLogRecalculationMode.duration,
  ]);

  final DateTime date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Duration? duration;
  final GameLogRecalculationMode recalculationMode;

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
  String toString() => 'GameLogAssistantState { '
      'date: $date, '
      'startTime: $startTime, '
      'endTime: $endTime, '
      'duration: $duration, '
      'recalculationMode: $recalculationMode'
      ' }';
}
