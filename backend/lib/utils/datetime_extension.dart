extension DateExtension on DateTime {
  bool isSameDay(DateTime other) {
    return day == other.day && isInMonthAndYearOf(other);
  }

  DateTime getMondayOfWeek() {
    DateTime mondayOfDate;

    if (weekday == DateTime.monday) {
      mondayOfDate = this;
    } else {
      final int daysToRemove = weekday - DateTime.monday;
      mondayOfDate = substractDays(daysToRemove);
    }

    return mondayOfDate;
  }

  DateTime getSundayOfWeek() {
    DateTime sundayOfDate;

    if (weekday == DateTime.sunday) {
      sundayOfDate = this;
    } else {
      final int daysToAdd = DateTime.sunday - weekday;
      sundayOfDate = addDays(daysToAdd);
    }

    return sundayOfDate;
  }

  bool isInWeekOf(DateTime other) {
    bool resultFound = false;

    DateTime dateInWeek = other.getMondayOfWeek();
    for (int index = 0; index < 7 && !resultFound; index++) {
      resultFound = isSameDay(dateInWeek);

      dateInWeek = dateInWeek.addDays(1);
    }

    return resultFound;
  }

  DateTime getFirstDayOfMonth() {
    return DateTime(year, month, 1);
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
}
