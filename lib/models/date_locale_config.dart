import 'package:intl/intl.dart';

final class DateLocaleConfig {
  final int startingDayOfWeek;
  final List<int> weekendDays;
  final DateFormat dateTimeFormat;
  final DateFormat dateFormat;
  final DateFormat timeFormat;

  const DateLocaleConfig({
    required this.startingDayOfWeek,
    required this.weekendDays,
    required this.dateTimeFormat,
    required this.dateFormat,
    required this.timeFormat,
  });

  DateLocaleConfig.def()
    : this(
        startingDayOfWeek: DateTime.monday,
        weekendDays: [DateTime.saturday, DateTime.sunday],
        dateTimeFormat: DateFormat.yMd().add_Hm(),
        dateFormat: DateFormat.yMd(),
        timeFormat: DateFormat.Hm(),
      );
}
