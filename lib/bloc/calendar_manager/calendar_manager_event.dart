import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class CalendarManagerEvent extends Equatable {
  const CalendarManagerEvent();

  @override
  List<Object> get props => [];
}

class AddTimeLog extends CalendarManagerEvent {
  const AddTimeLog(this.log);

  final TimeLog log;

  @override
  List<Object> get props => [log];

  @override
  String toString() => 'AddTimeLog { '
      'log: $log'
      ' }';
}

class DeleteTimeLog extends CalendarManagerEvent {
  const DeleteTimeLog(this.log);

  final TimeLog log;

  @override
  List<Object> get props => [log];

  @override
  String toString() => 'DeleteTimeLog { '
      'log: $log'
      ' }';
}

class AddFinishDate extends CalendarManagerEvent {
  const AddFinishDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'AddFinishDate { '
      'date: $date'
      ' }';
}

class DeleteFinishDate extends CalendarManagerEvent {
  const DeleteFinishDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'DeleteFinishDate { '
      'date: $date'
      ' }';
}