import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:game_collection_client/api.dart' show GameLogDTO;

import 'package:logic/model/model.dart' show CalendarRange;
import 'package:logic/utils/datetime_extension.dart';

import 'package:game_oclock/ui/common/statistics_histogram.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../theme/theme.dart' show GameTheme, CalendarTheme;

class CalendarUtils {
  CalendarUtils._();

  static TableCalendar<DateTime> buildTableCalendar(
    BuildContext context, {
    required DateTime firstDay,
    required DateTime lastDay,
    required DateTime focusedDay,
    required DateTime selectedDay,
    required Set<DateTime> logDays,
    required void Function(DateTime) onDaySelected,
    List<DateTime>? finishes,
    void Function(DateTime)? onPageChanged,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color headerColor = colorScheme.onSurface.withOpacity(0.60);
    final Color enabledColor = colorScheme.onSurface.withOpacity(0.87);
    final Color disabledColor = colorScheme.onSurface.withOpacity(0.38);

    return TableCalendar<DateTime>(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (DateTime day) {
        return day.isSameDay(selectedDay);
      },
      onDaySelected: (DateTime newSelectedDay, _) =>
          onDaySelected(newSelectedDay),
      eventLoader: (DateTime day) {
        return logDays
            .where((DateTime logDay) => day.isSameDay(logDay))
            .toList(growable: false);
      },
      holidayPredicate: finishes != null
          ? (DateTime day) {
              return finishes.any((DateTime finish) => day.isSameDay(finish));
            }
          : null,
      startingDayOfWeek: StartingDayOfWeek.monday,
      weekendDays: const <int>[DateTime.saturday, DateTime.sunday],
      pageJumpingEnabled: true,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const <CalendarFormat, String>{
        CalendarFormat.month: '',
      },
      onPageChanged: onPageChanged,
      rowHeight: 65.0,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: false,

        /// TODAY
        todayDecoration: const BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(
              color: CalendarTheme.todayColour,
              width: 2.0,
            ),
          ),
          shape: CalendarTheme.shape,
        ),
        todayTextStyle: TextStyle(color: enabledColor),

        /// SELECTED
        selectedDecoration: const BoxDecoration(
          color: CalendarTheme.selectedColour,
          shape: CalendarTheme.shape,
        ),
        selectedTextStyle: TextStyle(color: enabledColor),

        ///EVENTS - Logs
        markersMaxCount: 1,
        markersAlignment: Alignment.bottomRight,
        markerSizeScale: 0.35,
        markerDecoration: const BoxDecoration(
          color: GameTheme.playingStatusColour,
          shape: CalendarTheme.shape,
        ),

        ///HOLIDAY - Finish dates
        holidayDecoration: BoxDecoration(
          color: GameTheme.finishedColour,
          shape: CalendarTheme.shape,
        ),
        holidayTextStyle: const TextStyle(color: Colors.white),

        /// TextStyle - Like Calendar Date Picker
        // Enabled
        defaultTextStyle: TextStyle(color: enabledColor),
        weekendTextStyle: TextStyle(color: enabledColor),
        // Disabled
        outsideTextStyle: TextStyle(color: disabledColor),
        disabledTextStyle: TextStyle(color: disabledColor),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: headerColor, fontSize: 13.0),
        weekendStyle: TextStyle(color: headerColor, fontSize: 13.0),
      ),
    );
  }

  static String titleString(
    BuildContext context,
    DateTime date,
    CalendarRange range,
  ) {
    String rangeDateString;
    switch (range) {
      case CalendarRange.day:
        rangeDateString = AppLocalizationsUtils.formatDate(date);
        break;
      case CalendarRange.week:
        rangeDateString =
            '${AppLocalizationsUtils.formatDate(date.atMondayOfWeek())} ⮕ ${AppLocalizationsUtils.formatDate(date.atSundayOfWeek())}';
        break;
      case CalendarRange.month:
        rangeDateString =
            MaterialLocalizations.of(context).formatMonthYear(date);
        break;
      case CalendarRange.year:
        rangeDateString = MaterialLocalizations.of(context).formatYear(date);
        break;
    }
    return '${AppLocalizations.of(context)!.gameLogsFieldString} - $rangeDateString (${CalendarUtils.rangeString(context, range)})';
  }

  static String rangeString(BuildContext context, CalendarRange range) {
    switch (range) {
      case CalendarRange.day:
        return AppLocalizations.of(context)!.dayString;
      case CalendarRange.week:
        return AppLocalizations.of(context)!.weekString;
      case CalendarRange.month:
        return AppLocalizations.of(context)!.monthString;
      case CalendarRange.year:
        return AppLocalizations.of(context)!.yearString;
    }
  }

  static Widget buildGameLogsGraph(
    BuildContext context,
    List<GameLogDTO> gameLogs,
    CalendarRange range,
  ) {
    List<int> values = <int>[];
    List<String> labels = <String>[];

    if (range == CalendarRange.day) {
      // Create list where each entry is the time in an hour
      values = List<int>.filled(TimeOfDay.hoursPerDay, 0, growable: false);
      for (final GameLogDTO log in gameLogs) {
        int currentHour = log.startDatetime.hour;
        final int pendingMinToChangeHour =
            TimeOfDay.minutesPerHour - log.startDatetime.minute;
        final int logMin = log.time.inMinutes;

        if (pendingMinToChangeHour > logMin) {
          // Not enough time to change hour, put the whole log time
          values[currentHour] = logMin;
        } else {
          // Enough time, put time to change hour
          values[currentHour] = pendingMinToChangeHour;

          // Now compute for next hours
          int leftMin = logMin - pendingMinToChangeHour;
          while (leftMin > 0) {
            currentHour++;

            if (TimeOfDay.minutesPerHour >= leftMin) {
              // Less than an hour left, put whole time left
              values[currentHour] = leftMin;

              leftMin = 0;
            } else {
              // More than an hour left, put hour and continue for next hours
              values[currentHour] = TimeOfDay.minutesPerHour;

              leftMin -= TimeOfDay.minutesPerHour;
            }
          }
        }
      }

      // TODO Only show labels for 6, 12 and 18 hours
      labels = List<String>.generate(TimeOfDay.hoursPerDay, (int index) {
        return MaterialLocalizations.of(context).formatTimeOfDay(
          TimeOfDay(hour: index, minute: 0),
          alwaysUse24HourFormat: true,
        );
      });
    } else {
      values = gameLogs.map<int>((GameLogDTO log) {
        return log.time.inMinutes;
      }).toList(growable: false);

      if (range == CalendarRange.week) {
        labels = AppLocalizationsUtils.daysOfWeekAbbr();
      } else if (range == CalendarRange.month) {
        labels = List<String>.generate(
          gameLogs.length,
          (int index) => (index + 1).toString(), // No need for intl
        );
      } else if (range == CalendarRange.year) {
        labels = AppLocalizationsUtils.monthsAbbr();
      }
    }

    if (range == CalendarRange.day || range == CalendarRange.month) {
      return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 2,
            child: StatisticsHistogram<int>(
              id: 'gameLogsChart',
              domainLabels: labels,
              values: values,
              vertical: true,
              hideDomainLabels: false,
              valueFormatter: (int value) =>
                  AppLocalizationsUtils.formatDuration(
                context,
                Duration(minutes: value),
              ),
            ),
          ),
        ],
      );
    } else {
      return StatisticsHistogram<int>(
        id: 'gameLogsChart',
        domainLabels: labels,
        values: values,
        vertical: true,
        hideDomainLabels: false,
        valueFormatter: (int value) => AppLocalizationsUtils.formatDuration(
          context,
          Duration(minutes: value),
        ),
      );
    }
  }
}
