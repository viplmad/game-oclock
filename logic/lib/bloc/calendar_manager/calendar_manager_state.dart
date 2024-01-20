import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

abstract class CalendarManagerState extends Equatable {
  const CalendarManagerState();

  @override
  List<Object> get props => <Object>[];
}

class CalendarManagerInitialised extends CalendarManagerState {}

class CalendarNotLoaded extends CalendarManagerState {
  const CalendarNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'CalendarNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
