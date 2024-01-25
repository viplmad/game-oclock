import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import 'package:logic/model/model.dart' show GameLogRecalculationMode;

abstract class GameLogAssistantEvent extends Equatable {
  const GameLogAssistantEvent();

  @override
  List<Object> get props => <Object>[];
}

abstract class UpdateGameLogDate extends GameLogAssistantEvent {
  const UpdateGameLogDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => <Object>[date];
}

class UpdateGameLogStartDate extends UpdateGameLogDate {
  const UpdateGameLogStartDate(super.date);

  @override
  String toString() => 'UpdateGameLogStartDate { '
      'date: $date'
      ' }';
}

class UpdateGameLogEndDate extends UpdateGameLogDate {
  const UpdateGameLogEndDate(super.date);

  @override
  String toString() => 'UpdateGameLogEndDate { '
      'date: $date'
      ' }';
}

abstract class UpdateGameLogTime extends GameLogAssistantEvent {
  const UpdateGameLogTime(this.time);

  final TimeOfDay time;

  @override
  List<Object> get props => <Object>[time];
}

class UpdateGameLogStartTime extends UpdateGameLogTime {
  const UpdateGameLogStartTime(super.time);

  @override
  String toString() => 'UpdateGameLogStartTime { '
      'time: $time'
      ' }';
}

class UpdateGameLogEndTime extends UpdateGameLogTime {
  const UpdateGameLogEndTime(super.time);

  @override
  String toString() => 'UpdateGameLogEndTime { '
      'time: $time'
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
