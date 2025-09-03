import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:table_calendar/table_calendar.dart';

class LogCalendarHeader extends StatelessWidget {
  const LogCalendarHeader({
    super.key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.onPageChanged,
  });

  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final ValueChanged<DateTime> onPageChanged;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(CommonIcons.left),
            onPressed: () {
              final prevMonth = focusedDay.atFirstDayOfPreviousMonth();
              if (prevMonth.isAfter(firstDay) ||
                  prevMonth.isInSameMonthAndYearOf(firstDay)) {
                onPageChanged(
                  prevMonth.isInSameMonthAndYearOf(firstDay)
                      ? firstDay
                      : prevMonth,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(CommonIcons.right),
            onPressed: () {
              final nextMonth = focusedDay.atFirstDayOfNextMonth();
              if (nextMonth.isBefore(lastDay) ||
                  nextMonth.isInSameMonthAndYearOf(lastDay)) {
                onPageChanged(
                  nextMonth.isInSameMonthAndYearOf(lastDay)
                      ? lastDay
                      : nextMonth,
                );
              }
            },
          ),
        ],
      ),
      title: Text('${focusedDay.month}-${focusedDay.year}'), // TODO
    );
  }
}

class LogCalendar extends StatelessWidget {
  const LogCalendar({
    super.key,
    required this.logDays,
    // TODO List<DateTime>? finishes,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final Set<DateTime> logDays;

  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  static const BoxShape shape = BoxShape.circle;
  static const Color todayColour = Colors.red;
  static const Color selectedColour = Colors.red;
  static const Color logColour = Colors.blueAccent;
  static Color finishedColour = Colors.grey[800]!;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color headerColor = colorScheme.onSurface.withValues(alpha: 0.60);
    final Color enabledColor = colorScheme.onSurface.withValues(alpha: 0.87);
    final Color disabledColor = colorScheme.onSurface.withValues(alpha: 0.38);

    return TableCalendar<DateTime>(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (final DateTime day) {
        return day.isSameDay(selectedDay);
      },
      onDaySelected: (final DateTime newSelectedDay, _) =>
          onDaySelected(newSelectedDay),
      eventLoader: (final DateTime day) {
        return logDays
            .where((final DateTime logDay) => day.isSameDay(logDay))
            .toList(growable: false);
      },
      /* TODO holidayPredicate: finishes != null
          ? (DateTime day) {
              return finishes.any((DateTime finish) => day.isSameDay(finish));
            }
          : null,*/
      startingDayOfWeek: StartingDayOfWeek.monday, // TODO
      weekendDays: const <int>[DateTime.saturday, DateTime.sunday], // TODO
      pageJumpingEnabled: true,
      availableGestures: AvailableGestures.horizontalSwipe,
      headerVisible: false,
      onPageChanged: onPageChanged,
      rowHeight: 65.0,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: false,

        /// TODAY
        todayDecoration: const BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(color: todayColour, width: 2.0),
          ),
          shape: shape,
        ),
        todayTextStyle: TextStyle(color: enabledColor),

        /// SELECTED
        selectedDecoration: const BoxDecoration(
          color: selectedColour,
          shape: shape,
        ),
        selectedTextStyle: TextStyle(color: enabledColor),

        ///EVENTS - Logs
        markersMaxCount: 1,
        markersAlignment: Alignment.bottomRight,
        markerSizeScale: 0.35,
        markerDecoration: const BoxDecoration(color: logColour, shape: shape),

        ///HOLIDAY - Finish dates
        holidayDecoration: BoxDecoration(color: finishedColour, shape: shape),
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
}
