extension DateOnlyCompare on DateTime {
  bool isSameDay(DateTime other) {
    return this.day == other.day && this.isInMonthAndYearOf(other);
  }

  DateTime getMondayOfWeek() {
    DateTime mondayOfDate;

    if(this.weekday == 1) {
      mondayOfDate = this;
    } else {
      final int daysToRemove = this.weekday - 1;
      mondayOfDate = this.subtract(Duration(days: daysToRemove));
    }

    return mondayOfDate;
  }

  bool isInWeekOf(DateTime other) {
    bool resultFound = false;

    final Duration dayDuration = const Duration(days: 1);
    DateTime dateInWeek = other.getMondayOfWeek();
    for(int index = 0; index < 7 && !resultFound; index++) {
      resultFound = this.isSameDay(dateInWeek);

      dateInWeek = dateInWeek.add(dayDuration);
    }

    return resultFound;
  }

  DateTime getFirstDayOfMonth() {
    return DateTime(this.year, this.month, 1);
  }

  bool isInMonthAndYearOf(DateTime other) {
    return this.month == other.month && this.isInYearOf(other);
  }

  bool isInYearOf(DateTime other) {
    return this.year == other.year;
  }

  DateTime toDate() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime addDays(int days) {
    return this.add(Duration(days: days));
  }
}