import 'package:intl/intl.dart';

final class DateLocaleConfig {
  final int startingDayOfWeek;
  final List<int> weekendDays;
  final DateFormat dateFormat;

  const DateLocaleConfig({
    required this.startingDayOfWeek,
    required this.weekendDays,
    required this.dateFormat,
  });

  DateLocaleConfig.def()
    : this(
        startingDayOfWeek: DateTime.monday,
        weekendDays: [DateTime.saturday, DateTime.sunday],
        dateFormat: DateFormat.yMd(),
      );
}
