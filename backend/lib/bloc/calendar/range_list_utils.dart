import 'package:backend/utils/datetime_extension.dart';

import 'package:backend/model/model.dart' show GameTimeLog;
import 'package:backend/model/calendar_range.dart';


class RangeListUtils {
  RangeListUtils._();

  static bool doesNewDateNeedRecalculation(DateTime date, DateTime previousDate, CalendarRange range) {
    return (range == CalendarRange.Day && !date.isSameDay(previousDate))
      || (range == CalendarRange.Week && !date.isInWeekOf(previousDate))
      || (range == CalendarRange.Month && !date.isInMonthAndYearOf(previousDate))
      || (range == CalendarRange.Year && !date.isInYearOf(previousDate));
  }

  static List<GameTimeLog> createTimeLogListByRange(List<GameTimeLog> timeLogs, DateTime date, CalendarRange range) {
    List<GameTimeLog> selectedTimeLogs = <GameTimeLog>[];

    switch(range) {
      case CalendarRange.Day:
        selectedTimeLogs = timeLogs
          .where((GameTimeLog log) => log.dateTime.isSameDay(date))
          .toList(growable: false);
        break;
      case CalendarRange.Week: // Create a List of 7 timelogs -> sum of each day of week
        final DateTime mondayOfSelectedDate = date.getMondayOfWeek();

        DateTime dateOfWeek = mondayOfSelectedDate;
        for(int weekIndex = 0; weekIndex < 7; weekIndex++) {
          final Iterable<GameTimeLog> dayTimeLogs = timeLogs.where((GameTimeLog log) => log.dateTime.isSameDay(dateOfWeek));

          if(dayTimeLogs.isNotEmpty) {
            final Duration dayTimeSum = dayTimeLogs.fold<Duration>(const Duration(), (Duration previousValue, GameTimeLog log) => previousValue + log.time);

            selectedTimeLogs.add(
              GameTimeLog(dateTime: dateOfWeek, time: dayTimeSum),
            );
          } else {
            selectedTimeLogs.add(
              GameTimeLog(dateTime: dateOfWeek, time: const Duration()),
            );
          }

          dateOfWeek = dateOfWeek.addDays(1);
        }
        break;
      case CalendarRange.Month: // Create a List of 31* timelogs -> sum of each day of month
        final DateTime firstDayOfSelectedMonth = date.getFirstDayOfMonth();

        DateTime dateOfMonth = firstDayOfSelectedMonth;
        while(dateOfMonth.isInMonthAndYearOf(date)) { // While month does not change
          final Iterable<GameTimeLog> dayTimeLogs = timeLogs.where((GameTimeLog log) => log.dateTime.isSameDay(dateOfMonth));

          if(dayTimeLogs.isNotEmpty) {
            final Duration dayTimeSum = dayTimeLogs.fold<Duration>(const Duration(), (Duration previousValue, GameTimeLog log) => previousValue + log.time);

            selectedTimeLogs.add(
              GameTimeLog(dateTime: dateOfMonth, time: dayTimeSum),
            );
          } else {
            selectedTimeLogs.add(
              GameTimeLog(dateTime: dateOfMonth, time: const Duration()),
            );
          }

          dateOfMonth = dateOfMonth.addDays(1);
        }
        break;
      case CalendarRange.Year: // Create a List of 12 timelogs -> sum of each month of year
        for(int monthIndex = 1; monthIndex <= 12; monthIndex++) {
          final DateTime firstDayOfMonth = DateTime(date.year, monthIndex, 1);

          final Iterable<GameTimeLog> monthTimeLogs = timeLogs.where((GameTimeLog log) => log.dateTime.isInMonthAndYearOf(firstDayOfMonth));

          if(monthTimeLogs.isNotEmpty) {
            final Duration dayTimeSum = monthTimeLogs.fold<Duration>(const Duration(), (Duration previousValue, GameTimeLog log) => previousValue + log.time);

            selectedTimeLogs.add(
              GameTimeLog(dateTime: firstDayOfMonth, time: dayTimeSum),
            );
          } else {
            selectedTimeLogs.add(
              GameTimeLog(dateTime: firstDayOfMonth, time: const Duration()),
            );
          }
        }
        break;
    }

    return selectedTimeLogs;
  }

  static DateTime getPreviousDateWithLogs(Set<DateTime> logDates, DateTime selectedDate, CalendarRange range) {
    DateTime? previousDate;

    if(logDates.isNotEmpty) {
      final List<DateTime> listLogDates = logDates.toList(growable: false);
      int selectedIndex = listLogDates.indexWhere((DateTime date) => date.isSameDay(selectedDate));
      selectedIndex = (selectedIndex.isNegative)? listLogDates.length : selectedIndex;

      for(int index = selectedIndex - 1; index >= 0 && previousDate == null; index--) {
        final DateTime date = listLogDates.elementAt(index);

        if(date.isBefore(selectedDate)) { // Find previous day with logs
          if(range == CalendarRange.Day
            // Week range -> Need to be previous week
            || (range == CalendarRange.Week && !date.isInWeekOf(selectedDate))
            // Month range -> Need to be previous month
            || (range == CalendarRange.Month && !date.isInMonthAndYearOf(selectedDate))
            // Year range -> Need to be previous year
            || (range == CalendarRange.Year && !date.isInYearOf(selectedDate))) {
            previousDate = date;
          }
        }
      }
    }

    return previousDate?? selectedDate;
  }

  static DateTime getNextDateWithLogs(Set<DateTime> logDates, DateTime selectedDate, CalendarRange range) {
    DateTime? nextDate;

    if(logDates.isNotEmpty) {
      final List<DateTime> listLogDates = logDates.toList(growable: false);
      int selectedIndex = listLogDates.indexWhere((DateTime date) => date.isSameDay(selectedDate));
      selectedIndex = (selectedIndex.isNegative)? 0 : selectedIndex;

      for(int index = selectedIndex + 1; index < listLogDates.length && nextDate == null; index++) {
        final DateTime date = listLogDates.elementAt(index);

        if(date.isAfter(selectedDate)) { // Find next day with logs
          if(range == CalendarRange.Day
            // Week range -> Need to be next week
            || (range == CalendarRange.Week && !date.isInWeekOf(selectedDate))
            // Month range -> Need to be next month
            || (range == CalendarRange.Month && !date.isInMonthAndYearOf(selectedDate))
            // Year range -> Need to be next year
            || (range == CalendarRange.Year && !date.isInYearOf(selectedDate))) {
            nextDate = date;
          }
        }
      }
    }

    return nextDate?? selectedDate;
  }
}