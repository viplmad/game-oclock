extension DateExtension on DateTime {
  bool isSameDay(DateTime other) {
    return this.day == other.day && this.isInMonthAndYearOf(other);
  }

  DateTime getMondayOfWeek() {
    DateTime mondayOfDate;

    if(this.weekday == DateTime.monday) {
      mondayOfDate = this;
    } else {
      final int daysToRemove = this.weekday - DateTime.monday;
      mondayOfDate = this.substractDays(daysToRemove);
    }

    return mondayOfDate;
  }

  DateTime getSundayOfWeek() {
    DateTime sundayOfDate;

    if(this.weekday == DateTime.sunday) {
      sundayOfDate = this;
    } else {
      final int daysToAdd = DateTime.sunday - this.weekday;
      sundayOfDate = this.addDays(daysToAdd);
    }

    return sundayOfDate;
  }

  bool isInWeekOf(DateTime other) {
    bool resultFound = false;

    DateTime dateInWeek = other.getMondayOfWeek();
    for(int index = 0; index < 7 && !resultFound; index++) {
      resultFound = this.isSameDay(dateInWeek);

      dateInWeek = dateInWeek.addDays(1);
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

  DateTime substractDays(int days) {
    return this.subtract(Duration(days: days));
  }
}