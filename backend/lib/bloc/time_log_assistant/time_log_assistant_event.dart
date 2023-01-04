import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import 'time_log_recalculation_mode.dart';

abstract class GameLogAssistantEvent extends Equatable {
  const GameLogAssistantEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateGameLogDate extends GameLogAssistantEvent {
  const UpdateGameLogDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => <Object>[date];

  @override
  String toString() => 'UpdateGameLogDate { '
      'date: $date'
      ' }';
}

class UpdateGameLogStartTime extends GameLogAssistantEvent {
  const UpdateGameLogStartTime(this.startTime);

  final TimeOfDay startTime;

  @override
  List<Object> get props => <Object>[startTime];

  @override
  String toString() => 'UpdateGameLogStartTime { '
      'startTime: $startTime'
      ' }';
}

class UpdateGameLogEndTime extends GameLogAssistantEvent {
  const UpdateGameLogEndTime(this.endTime);

  final TimeOfDay endTime;

  @override
  List<Object> get props => <Object>[endTime];

  @override
  String toString() => 'UpdateGameLogEndTime { '
      'endTime: $endTime'
      ' }';
}

class UpdateGameLogDuration extends GameLogAssistantEvent {
  const UpdateGameLogDuration(this.duration);

  final Duration duration;

  @override
  List<Object> get props => <Object>[duration];

  @override
  String toString() => 'UpdateGameLogDuration { '
      'duration: $duration'
      ' }';
}

class UpdateGameLogRecalculationMode extends GameLogAssistantEvent {
  const UpdateGameLogRecalculationMode(this.mode);

  final GameLogRecalculationMode mode;

  @override
  List<Object> get props => <Object>[mode];

  @override
  String toString() => 'UpdateGameLogRecalculationMode { '
      'mode: $mode'
      ' }';
}
