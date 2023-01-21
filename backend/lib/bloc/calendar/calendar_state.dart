import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => <Object>[];
}

class CalendarLoading extends CalendarState {}

class CalendarError extends CalendarState {}
