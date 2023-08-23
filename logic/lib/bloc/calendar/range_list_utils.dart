import 'package:game_collection_client/api.dart' show GameLogDTO;

import 'package:logic/model/model.dart' show CalendarRange;
import 'package:logic/utils/datetime_extension.dart';

class RangeListUtils {
  RangeListUtils._();

  static bool doesNewDateNeedRecalculation(
    DateTime date,
    DateTime previousDate,
    CalendarRange range,
  ) {
    return (range == CalendarRange.day && !date.isSameDay(previousDate)) ||
        (range == CalendarRange.week && !date.isInWeekOf(previousDate)) ||
        (range == CalendarRange.month &&
            !date.isInMonthAndYearOf(previousDate)) ||
        (range == CalendarRange.year && !date.isInYearOf(previousDate));
  }

  static List<GameLogDTO> createGameLogListByRange(
    List<GameLogDTO> gameLogs,
    DateTime date,
    CalendarRange range,
  ) {
    List<GameLogDTO> selectedGameLogs = <GameLogDTO>[];

    switch (range) {
      case CalendarRange.day:
        selectedGameLogs = gameLogs
            .where((GameLogDTO log) => log.startDatetime.isSameDay(date))
            .toList(growable: false);
        break;
      case CalendarRange.week:
        // Create a List of 7 logs -> sum of each day of week
        final DateTime mondayOfSelectedDate = date.atMondayOfWeek();

        DateTime dateOfWeek = mondayOfSelectedDate;
        for (int weekIndex = 0; weekIndex < 7; weekIndex++) {
          final Iterable<GameLogDTO> dayGameLogs = gameLogs
              .where((GameLogDTO log) => log.startDatetime.isSameDay(dateOfWeek));

          if (dayGameLogs.isNotEmpty) {
            final Duration dayTimeSum = dayGameLogs.fold<Duration>(
              const Duration(),
              (Duration previousValue, GameLogDTO log) =>
                  previousValue + log.time,
            );

            selectedGameLogs.add(
              GameLogDTO(startDatetime: dateOfWeek, endDatetime: dateOfWeek, time: dayTimeSum),
            );
          } else {
            selectedGameLogs.add(
              GameLogDTO(startDatetime: dateOfWeek, endDatetime: dateOfWeek, time: const Duration()),
            );
          }

          dateOfWeek = dateOfWeek.addDays(1);
        }
        break;
      case CalendarRange.month:
        // Create a List of 31* logs -> sum of each day of month
        final DateTime firstDayOfSelectedMonth = date.atFirstDayOfMonth();

        DateTime dateOfMonth = firstDayOfSelectedMonth;
        while (dateOfMonth.isInMonthAndYearOf(date)) {
          // While month does not change
          final Iterable<GameLogDTO> dayGameLogs = gameLogs
              .where((GameLogDTO log) => log.startDatetime.isSameDay(dateOfMonth));

          if (dayGameLogs.isNotEmpty) {
            final Duration dayTimeSum = dayGameLogs.fold<Duration>(
              const Duration(),
              (Duration previousValue, GameLogDTO log) =>
                  previousValue + log.time,
            );

            selectedGameLogs.add(
              GameLogDTO(startDatetime: dateOfMonth, endDatetime: dateOfMonth, time: dayTimeSum),
            );
          } else {
            selectedGameLogs.add(
              GameLogDTO(startDatetime: dateOfMonth, endDatetime: dateOfMonth, time: const Duration()),
            );
          }

          dateOfMonth = dateOfMonth.addDays(1);
        }
        break;
      case CalendarRange.year:
        // Create a List of 12 logs -> sum of each month of year
        for (int monthIndex = 1; monthIndex <= 12; monthIndex++) {
          final DateTime firstDayOfMonth = DateTime(date.year, monthIndex, 1);

          final Iterable<GameLogDTO> monthGameLogs = gameLogs.where(
            (GameLogDTO log) =>
                log.startDatetime.isInMonthAndYearOf(firstDayOfMonth),
          );

          if (monthGameLogs.isNotEmpty) {
            final Duration dayTimeSum = monthGameLogs.fold<Duration>(
              const Duration(),
              (Duration previousValue, GameLogDTO log) =>
                  previousValue + log.time,
            );

            selectedGameLogs.add(
              GameLogDTO(startDatetime: firstDayOfMonth, endDatetime: firstDayOfMonth, time: dayTimeSum),
            );
          } else {
            selectedGameLogs.add(
              GameLogDTO(startDatetime: firstDayOfMonth, endDatetime: firstDayOfMonth, time: const Duration()),
            );
          }
        }
        break;
    }

    return selectedGameLogs;
  }

  static DateTime getPreviousDateWithLogs(
    Set<DateTime> logDates,
    DateTime selectedDate,
    CalendarRange range,
  ) {
    DateTime? previousDate;

    if (logDates.isNotEmpty) {
      final List<DateTime> listLogDates = logDates.toList(growable: false);
      int selectedIndex = listLogDates
          .indexWhere((DateTime date) => date.isSameDay(selectedDate));
      selectedIndex =
          (selectedIndex.isNegative) ? listLogDates.length : selectedIndex;

      for (int index = selectedIndex - 1;
          index >= 0 && previousDate == null;
          index--) {
        final DateTime date = listLogDates.elementAt(index);

        if (date.isBefore(selectedDate)) {
          // Find previous day with logs
          if ((range == CalendarRange.day && !date.isSameDay(selectedDate))
              // Week range -> Need to be previous week
              ||
              (range == CalendarRange.week && !date.isInWeekOf(selectedDate))
              // Month range -> Need to be previous month
              ||
              (range == CalendarRange.month &&
                  !date.isInMonthAndYearOf(selectedDate))
              // Year range -> Need to be previous year
              ||
              (range == CalendarRange.year && !date.isInYearOf(selectedDate))) {
            previousDate = date;
          }
        }
      }
    }

    return previousDate ?? selectedDate;
  }

  static DateTime getNextDateWithLogs(
    Set<DateTime> logDates,
    DateTime selectedDate,
    CalendarRange range,
  ) {
    DateTime? nextDate;

    if (logDates.isNotEmpty) {
      final List<DateTime> listLogDates = logDates.toList(growable: false);
      int selectedIndex = listLogDates
          .indexWhere((DateTime date) => date.isSameDay(selectedDate));
      selectedIndex = (selectedIndex.isNegative) ? 0 : selectedIndex;

      for (int index = selectedIndex + 1;
          index < listLogDates.length && nextDate == null;
          index++) {
        final DateTime date = listLogDates.elementAt(index);

        if (date.isAfter(selectedDate)) {
          // Find next day with logs
          if ((range == CalendarRange.day && !date.isSameDay(selectedDate))
              // Week range -> Need to be next week
              ||
              (range == CalendarRange.week && !date.isInWeekOf(selectedDate))
              // Month range -> Need to be next month
              ||
              (range == CalendarRange.month &&
                  !date.isInMonthAndYearOf(selectedDate))
              // Year range -> Need to be next year
              ||
              (range == CalendarRange.year && !date.isInYearOf(selectedDate))) {
            nextDate = date;
          }
        }
      }
    }

    return nextDate ?? selectedDate;
  }
}
