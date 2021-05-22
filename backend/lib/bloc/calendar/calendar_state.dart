import 'package:equatable/equatable.dart';


abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => <Object>[];
}

class CalendarLoading extends CalendarState {}

class CalendarNotLoaded extends CalendarState {
  const CalendarNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'CalendarNotLoaded { '
      'error: $error'
      ' }';
}