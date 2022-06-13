import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show GameFinish, GameTimeLog;
import 'package:backend/model/calendar_range.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'package:game_collection/localisations/localisations.dart';
import 'package:table_calendar/table_calendar.dart';

import '../common/statistics_histogram.dart';
import '../theme/calendar_theme.dart';

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
    List<GameFinish>? finishes,
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
              return finishes
                  .any((GameFinish finish) => day.isSameDay(finish.dateTime));
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
          color: CalendarTheme.playedColour,
          shape: CalendarTheme.shape,
        ),

        ///HOLIDAY - Finish dates
        holidayDecoration: const BoxDecoration(
          color: CalendarTheme.finishedColour,
          shape: CalendarTheme.shape,
        ),
        holidayTextStyle: const TextStyle(color: Color(0xFF5A5A5A)),

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
        rangeDateString =
            GameCollectionLocalisations.of(context).formatDate(date);
        break;
      case CalendarRange.week:
        rangeDateString =
            '${GameCollectionLocalisations.of(context).formatDate(date.getMondayOfWeek())} ⮕ ${GameCollectionLocalisations.of(context).formatDate(date.getSundayOfWeek())}';
        break;
      case CalendarRange.month:
        rangeDateString =
            GameCollectionLocalisations.of(context).formatMonthYear(date);
        break;
      case CalendarRange.year:
        rangeDateString =
            GameCollectionLocalisations.of(context).formatYear(date.year);
        break;
    }
    return '${GameCollectionLocalisations.of(context).timeLogsFieldString} - $rangeDateString (${GameCollectionLocalisations.of(context).rangeString(range)})';
  }

  static Widget buildTimeLogsGraph(
    BuildContext context,
    List<GameTimeLog> timeLogs,
    CalendarRange range,
  ) {
    List<int> values = <int>[];
    List<String> labels = <String>[];

    if (range == CalendarRange.day) {
      // Create list where each entry is the time in an hour
      values = List<int>.filled(24, 0, growable: false);
      for (final GameTimeLog log in timeLogs) {
        int currentHour = log.dateTime.hour;
        final int pendingMinToChangeHour = 60 - log.dateTime.minute;
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

            if (60 >= leftMin) {
              // Less than an hour left, put whole time left
              values[currentHour] = leftMin;

              leftMin = 0;
            } else {
              // More than an hour left, put hour and continue for next hours
              values[currentHour] = 60;

              leftMin -= 60;
            }
          }
        }
      }

      // TODO: Only show labels for 6, 12 and 18 hours
      labels = List<String>.generate(24, (int index) {
        return '$index:00';
      });
    } else {
      values = timeLogs.map<int>((GameTimeLog log) {
        return log.time.inMinutes;
      }).toList(growable: false);

      if (range == CalendarRange.week) {
        labels = GameCollectionLocalisations.of(context).shortDaysOfWeek;
      } else if (range == CalendarRange.month) {
        labels = List<String>.generate(
          values.length,
          (int index) => (index + 1).toString(),
        );
      } else if (range == CalendarRange.year) {
        labels = GameCollectionLocalisations.of(context).shortMonths;
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
              histogramName:
                  GameCollectionLocalisations.of(context).timeLogsFieldString,
              domainLabels: labels,
              values: values,
              vertical: true,
              hideDomainLabels: false,
              valueFormatter: (int value) =>
                  GameCollectionLocalisations.of(context)
                      .formatDuration(Duration(minutes: value)),
            ),
          ),
        ],
      );
    } else {
      return StatisticsHistogram<int>(
        histogramName:
            GameCollectionLocalisations.of(context).timeLogsFieldString,
        domainLabels: labels,
        values: values,
        vertical: true,
        hideDomainLabels: false,
        valueFormatter: (int value) => GameCollectionLocalisations.of(context)
            .formatDuration(Duration(minutes: value)),
      );
    }
  }
}
