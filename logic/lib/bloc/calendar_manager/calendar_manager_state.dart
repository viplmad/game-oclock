import 'package:equatable/equatable.dart';

abstract class CalendarManagerState extends Equatable {
  const CalendarManagerState();

  @override
  List<Object> get props => <Object>[];
}

class CalendarManagerInitialised extends CalendarManagerState {}

class CalendarNotLoaded extends CalendarManagerState {
  const CalendarNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'CalendarNotLoaded { '
      'error: $error'
      ' }';
}
