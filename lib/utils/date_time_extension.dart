extension DateTimeExtension on DateTime {
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

  DateTime atFirstDayOfNextMonth() {
    final nextMonth = (month + 1) % 12;
    final newYear = nextMonth == 1;
    return DateTime(newYear ? year + 1 : year, nextMonth, 1);
  }

  DateTime atFirstDayOfPreviousMonth() {
    final nextMonth = (month - 1) % 12;
    final newYear = nextMonth == 12;
    return DateTime(newYear ? year - 1 : year, nextMonth, 1);
  }
}
