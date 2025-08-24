extension DateTimeExtension on DateTime {
  bool isSameDay(final DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  /// Returns `date` in UTC format, without its time part.
  DateTime normalizeDate() {
    return DateTime.utc(year, month, day);
  }
}
