extension DateTimeExtension on DateTime {
  bool isSameDay(final DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}
