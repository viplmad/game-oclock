import 'package:equatable/equatable.dart';

abstract class CalendarManagerEvent extends Equatable {
  const CalendarManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class WarnCalendarNotLoaded extends CalendarManagerEvent {
  const WarnCalendarNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'WarnCalendarNotLoaded { '
      'error: $error'
      ' }';
}
