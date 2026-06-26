import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toIso8601WithTzString() {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(this) + toTzString();
  }

  String toTzString() {
    final offset = timeZoneOffset;
    final hours = offset.inHours > 0
        ? offset.inHours
        : 1; // For fixing divide by 0

    if (!offset.isNegative) {
      return '+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}';
    } else {
      return '-${(-offset.inHours).toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}';
    }
  }

  int daysDifference(final DateTime other) {
    return normalizeDate().difference(other.normalizeDate()).inDays;
  }

  bool isSameDay(final DateTime other) {
    return day == other.day && isInSameMonthAndYearOf(other);
  }

  bool isInSameMonthAndYearOf(final DateTime other) {
    return month == other.month && year == other.year;
  }

  /// Returns `date` in UTC format, without its time part.
  DateTime normalizeDate() {
    return DateTime.utc(year, month, day);
  }

  DateTime addDays(final int days) {
    return add(Duration(days: days));
  }

  DateTime atFirstDayOfNextMonth() {
    var nextMonth = (month + 1) % 12;
    nextMonth = nextMonth == 0 ? 12 : nextMonth;
    final newYear = nextMonth == 1;
    return DateTime(newYear ? year + 1 : year, nextMonth, 1);
  }

  DateTime atFirstDayOfPreviousMonth() {
    var nextMonth = (month - 1) % 12;
    nextMonth = nextMonth == 0 ? 12 : nextMonth;
    final newYear = nextMonth == 12;
    return DateTime(newYear ? year - 1 : year, nextMonth, 1);
  }
}
