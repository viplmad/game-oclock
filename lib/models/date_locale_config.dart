import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

final class DateLocaleConfig extends Equatable {
  final int? startingDayOfWeek;
  final DateFormat? dateFormat;
  final DateFormat? timeFormat;

  const DateLocaleConfig({
    this.startingDayOfWeek,
    this.dateFormat,
    this.timeFormat,
  });

  @override
  List<Object?> get props => [
    startingDayOfWeek,
    dateFormat?.pattern,
    timeFormat?.pattern,
  ];
}
