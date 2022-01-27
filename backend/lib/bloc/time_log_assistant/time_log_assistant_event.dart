import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import 'time_log_recalculation_mode.dart';


abstract class TimeLogAssistantEvent extends Equatable {
  const TimeLogAssistantEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateTimeLogDate extends TimeLogAssistantEvent {
  const UpdateTimeLogDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => <Object>[date];

  @override
  String toString() => 'UpdateTimeLogDate { '
      'date: $date'
      ' }';
}

class UpdateTimeLogStartTime extends TimeLogAssistantEvent {
  const UpdateTimeLogStartTime(this.startTime);

  final TimeOfDay startTime;

  @override
  List<Object> get props => <Object>[startTime];

  @override
  String toString() => 'UpdateTimeLogStartTime { '
      'startTime: $startTime'
      ' }';
}

class UpdateTimeLogEndTime extends TimeLogAssistantEvent {
  const UpdateTimeLogEndTime(this.endTime);

  final TimeOfDay endTime;

  @override
  List<Object> get props => <Object>[endTime];

  @override
  String toString() => 'UpdateTimeLogEndTime { '
      'endTime: $endTime'
      ' }';
}

class UpdateTimeLogDuration extends TimeLogAssistantEvent {
  const UpdateTimeLogDuration(this.duration);

  final Duration duration;

  @override
  List<Object> get props => <Object>[duration];

  @override
  String toString() => 'UpdateTimeLogDuration { '
      'duration: $duration'
      ' }';
}

class UpdateTimeLogRecalculationMode extends TimeLogAssistantEvent {
  const UpdateTimeLogRecalculationMode(this.mode);

  final TimeLogRecalculationMode mode;

  @override
  List<Object> get props => <Object>[mode];

  @override
  String toString() => 'UpdateTimeLogRecalculationMode { '
      'mode: $mode'
      ' }';
}