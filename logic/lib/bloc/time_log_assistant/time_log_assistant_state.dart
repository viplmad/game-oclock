import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import 'package:logic/model/model.dart' show GameLogRecalculationMode;

class GameLogAssistantState extends Equatable {
  const GameLogAssistantState(
    this.startDate,
    this.endDate, [
    this.startTime,
    this.endTime,
    this.duration,
    this.recalculationMode = GameLogRecalculationMode.duration,
  ]);

  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Duration? duration;
  final GameLogRecalculationMode recalculationMode;

  bool get isComplete =>
      startTime != null && endTime != null && duration != null;

  @override
  List<Object> get props => <Object>[
        startDate,
        endDate,
        startTime ?? TimeOfDay.now(),
        endTime ?? TimeOfDay.now(),
        duration ?? Duration.zero,
        recalculationMode,
      ];

  @override
  String toString() => 'GameLogAssistantState { '
      'startDate: $startDate, '
      'endDate: $endDate, '
      'startTime: $startTime, '
      'endTime: $endTime, '
      'duration: $duration, '
      'recalculationMode: $recalculationMode'
      ' }';
}
