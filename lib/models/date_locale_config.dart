import 'package:intl/intl.dart';

final class DateLocaleConfig {
  final int startingDayOfWeek;
  final List<int> weekendDays;
  final DateFormat dateFormat;
  final DateFormat timeFormat;

  DateFormat get dateTimeFormat => dateFormat.addPattern(timeFormat.pattern);

  const DateLocaleConfig({
    required this.startingDayOfWeek,
    required this.weekendDays,
    required this.dateFormat,
    required this.timeFormat,
  });

  DateLocaleConfig.def()
    : this(
        startingDayOfWeek: DateTime.monday,
        weekendDays: [DateTime.saturday, DateTime.sunday],
        dateFormat: DateFormat.yMd(),
        timeFormat: DateFormat.Hm(),
      );
}
