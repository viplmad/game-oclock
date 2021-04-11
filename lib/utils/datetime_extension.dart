extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
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
      resultFound = this.isSameDate(dateInWeek);

      dateInWeek = dateInWeek.add(dayDuration);
    }

    return resultFound;
  }

  DateTime toDate() {
    return DateTime(this.year, this.month, this.day);
  }
}