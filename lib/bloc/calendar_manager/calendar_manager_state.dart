import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class CalendarManagerState extends Equatable {
  const CalendarManagerState();

  @override
  List<Object> get props => [];
}

class Initialised extends CalendarManagerState {}

class TimeLogAdded extends CalendarManagerState {
  const TimeLogAdded(this.log);

  final TimeLog log;

  @override
  List<Object> get props => [log];

  @override
  String toString() => 'TimeLogAdded { '
      'log: $log'
      ' }';
}

class TimeLogNotAdded extends CalendarManagerState {
  const TimeLogNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'TimeLogNotAdded { '
      'error: $error'
      ' }';
}

class TimeLogDeleted extends CalendarManagerState {
  const TimeLogDeleted(this.log);

  final TimeLog log;

  @override
  List<Object> get props => [log];

  @override
  String toString() => 'TimeLogDeleted { '
      'item: $log'
      ' }';
}

class TimeLogNotDeleted extends CalendarManagerState {
  const TimeLogNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'TimeLogNotDeleted { '
      'error: $error'
      ' }';
}

class FinishDateAdded extends CalendarManagerState {
  const FinishDateAdded(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'FinishDateAdded { '
      'log: $date'
      ' }';
}

class FinishDateNotAdded extends CalendarManagerState {
  const FinishDateNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FinishDateNotAdded { '
      'error: $error'
      ' }';
}

class FinishDateDeleted extends CalendarManagerState {
  const FinishDateDeleted(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'FinishDateDeleted { '
      'item: $date'
      ' }';
}

class FinishDateNotDeleted extends CalendarManagerState {
  const FinishDateNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FinishDateNotDeleted { '
      'error: $error'
      ' }';
}