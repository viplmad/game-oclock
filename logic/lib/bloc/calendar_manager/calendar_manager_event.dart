import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

abstract class CalendarManagerEvent extends Equatable {
  const CalendarManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class WarnCalendarNotLoaded extends CalendarManagerEvent {
  const WarnCalendarNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'WarnCalendarNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
