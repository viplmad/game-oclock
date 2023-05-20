extension DateExtension on DateTime {
  bool isSameDay(DateTime other) {
    return day == other.day && isInMonthAndYearOf(other);
  }

  DateTime atMondayOfWeek() {
    DateTime dateAtMonday;

    if (weekday == DateTime.monday) {
      dateAtMonday = this;
    } else {
      final int daysToRemove = weekday - DateTime.monday;
      dateAtMonday = substractDays(daysToRemove);
    }

    return dateAtMonday;
  }

  DateTime atSundayOfWeek() {
    DateTime dateAtSunday;

    if (weekday == DateTime.sunday) {
      dateAtSunday = this;
    } else {
      final int daysToAdd = DateTime.sunday - weekday;
      dateAtSunday = addDays(daysToAdd);
    }

    return dateAtSunday;
  }

  bool isInWeekOf(DateTime other) {
    bool resultFound = false;

    DateTime dateInWeek = other.atMondayOfWeek();
    for (int index = 0; index < DateTime.daysPerWeek && !resultFound; index++) {
      resultFound = isSameDay(dateInWeek);

      dateInWeek = dateInWeek.addDays(1);
    }

    return resultFound;
  }

  DateTime atFirstDayOfMonth() {
    return DateTime(year, month, 1);
  }

  DateTime atLastDayOfMonth() {
    // Taken from https://stackoverflow.com/questions/14814941/how-to-find-last-day-of-month
    return month < DateTime.monthsPerYear
        ? DateTime(year, month + 1, 0)
        : DateTime(year + 1, DateTime.january, 0);
  }

  DateTime atFirstDayOfYear() {
    return DateTime(year, DateTime.january, 1);
  }

  DateTime atLastDayOfYear() {
    return DateTime(year, DateTime.december, 31);
  }

  bool isInMonthAndYearOf(DateTime other) {
    return month == other.month && isInYearOf(other);
  }

  bool isInYearOf(DateTime other) {
    return year == other.year;
  }

  DateTime toDate() {
    return DateTime(year, month, day);
  }

  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  DateTime substractDays(int days) {
    return subtract(Duration(days: days));
  }

  DateTime addMonths(int months) {
    return DateTime(year, month + months, day);
  }
}
