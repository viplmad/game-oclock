import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart' as tableCalendar;

import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/calendar/multi_calendar.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import '../common/loading_icon.dart';
import '../common/statistics_histogram.dart';
import '../detail/detail.dart';


class MultiGameCalendar extends StatelessWidget {
  const MultiGameCalendar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MultiCalendarBloc _bloc = MultiCalendarBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    return BlocProvider(
      create: (BuildContext context) {
        return _bloc..add(LoadCalendar(DateTime.now().year));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(GameCollectionLocalisations.of(context).calendarViewString),
          actions: [
            IconButton(
              icon: Icon(Icons.first_page),
              tooltip: GameCollectionLocalisations.of(context).firstTimeLog,
              onPressed: () {
                _bloc.add(UpdateSelectedDateFirst());
              },
            ),
            IconButton(
              icon: Icon(Icons.navigate_before),
              tooltip: GameCollectionLocalisations.of(context).previousTimeLog,
              onPressed: () {
                _bloc.add(UpdateSelectedDatePrevious());
              },
            ),
            IconButton(
              icon: Icon(Icons.navigate_next),
              tooltip: GameCollectionLocalisations.of(context).nextTimeLog,
              onPressed: () {
                _bloc.add(UpdateSelectedDateNext());
              },
            ),
            IconButton(
              icon: Icon(Icons.last_page),
              tooltip: GameCollectionLocalisations.of(context).lastTimeLog,
              onPressed: () {
                _bloc.add(UpdateSelectedDateLast());
              },
            ),
            IconButton(
              icon: Icon(Icons.insert_chart),
              tooltip: GameCollectionLocalisations.of(context).changeStyleString,
              onPressed: () {
                _bloc.add(UpdateStyle());
              },
            ),
          ],
        ),
        body: bodyBuilder(),
      ),
    );

  }

  _MultiGameCalendarBody bodyBuilder() {

    return _MultiGameCalendarBody();

  }

}

// ignore: must_be_immutable
class _MultiGameCalendarBody extends StatelessWidget {
  _MultiGameCalendarBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MultiCalendarBloc, MultiCalendarState>(
      builder: (BuildContext context, MultiCalendarState state) {

        if(state is CalendarLoaded) {

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildTableCalendar(context, state.logDates, state.selectedDate),
              const Divider(height: 4.0),
              ListTile(
                title: Text(GameCollectionLocalisations.of(context).timeLogsFieldString + ' - ' + GameCollectionLocalisations.of(context).dateString(state.selectedDate) + ((state.style == CalendarStyle.Graph)? ' (' + GameCollectionLocalisations.of(context).weekString + ')' : '')),
                trailing: Text(GameCollectionLocalisations.of(context).durationString(state.selectedTotalTime)),
              ),
              Expanded(child: (state.style == CalendarStyle.List)? _buildEventList(context, state.selectedGamesWithLogs) : Container()), // _buildEventGraph(context, state.selectedTimeLogs)),
            ],
          );

        }
        if(state is CalendarNotLoaded) {

          return Center(
            child: Text(state.error),
          );

        }

        return LoadingIcon();

      },
    );

  }

  Widget _buildTableCalendar(BuildContext context, Set<DateTime> logDates, DateTime selectedDate) {
    DateTime firstDate = DateTime.now();
    DateTime lastDate = firstDate;
    if(logDates.isNotEmpty) {
      firstDate = logDates.first;
      lastDate = logDates.last;
    }

    return tableCalendar.TableCalendar<DateTime>(
      firstDay: firstDate,
      lastDay: lastDate,
      focusedDay: selectedDate,
      selectedDayPredicate: (DateTime day) {
        return day.isSameDate(selectedDate);
      },
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        BlocProvider.of<MultiCalendarBloc>(context).add(
          UpdateSelectedDate(
            selectedDay,
          ),
        );
      },
      eventLoader: (DateTime date) {
        return logDates. where((DateTime logDate) => date.isSameDate(logDate)).toList(growable: false);
      },
      startingDayOfWeek: tableCalendar.StartingDayOfWeek.monday,
      weekendDays: const [
        DateTime.saturday,
        DateTime.sunday
      ],
      pageJumpingEnabled: true,
      availableGestures: tableCalendar.AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        tableCalendar.CalendarFormat.month: '',
      },
      headerStyle: const tableCalendar.HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      rowHeight: 65.0,
      calendarStyle: tableCalendar.CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Colors.yellow[800],
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: GameTheme.primaryColour,
          shape: BoxShape.circle,
        ),
        ///EVENTS
        markersMaxCount: 1,
        markersAlignment: Alignment.bottomRight,
        markerSizeScale: 0.35,
        markerDecoration: const BoxDecoration(
          color: GameTheme.playingStatusColour,
          shape: BoxShape.circle,
        ),
        ///HOLIDAY
        holidayDecoration: const BoxDecoration(
          color: GameTheme.playedStatusColour,
          shape: BoxShape.circle,
        ),
        holidayTextStyle: const TextStyle(color: const Color(0xFF5A5A5A)),
        ///WEEKEND
        weekendDecoration: BoxDecoration(
          color: Colors.grey.withAlpha(50),
          shape: BoxShape.circle,
        ),
        weekendTextStyle: const TextStyle(color: const Color(0xFF5A5A5A)),
      ),
    );
  }

  Widget _buildEventList(BuildContext context, List<GameWithLogs> gamesWithLogs) {

    if(gamesWithLogs.isEmpty) {
      return Center(
        child: Text(GameCollectionLocalisations.of(context).emptyTimeLogsString),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: gamesWithLogs.length,
      itemBuilder: (BuildContext context, int index) {
        GameWithLogs gameWithLogs = gamesWithLogs.elementAt(index);

        return Padding(
          padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
          child: GameTheme.itemCardWithTime(context, gameWithLogs.game, Duration(seconds: gameWithLogs.totalTimeSeconds()), onTap),
        );
      },
    );

  }

  void Function()? onTap(BuildContext context, Game item) {

    return () {
      Navigator.pushNamed(
        context,
        gameDetailRoute,
        arguments: DetailArguments<Game>(
          item: item,
          // TODO update if on tap
          /*onUpdate: (Game? updatedItem) {

            if(updatedItem != null) {

              BlocProvider.of<K>(context).add(UpdateListItem<T>(updatedItem));

            }

          },*/
        ),
      );
    };

  }

  /*Widget _buildEventGraph(BuildContext context, List<TimeLog> timeLogs) {
    List<int> values = <int>[];

    List<DateTime> distinctLogDates = <DateTime>[];
    timeLogs.forEach((TimeLog log) {
      if(!distinctLogDates.any((DateTime date) => date.isSameDate(log.dateTime))) {
        distinctLogDates.add(log.dateTime);
      }
    });
    distinctLogDates.sort();

    distinctLogDates.forEach((DateTime date) {
      List<Duration> dateDurations = timeLogs.where((TimeLog log) => log.dateTime.isSameDate(date)).map((TimeLog log) => log.time).toList(growable: false);
      int daySum = dateDurations.fold<int>(0, (int previousValue, Duration duration) => previousValue + duration.inMinutes);
      values.add(daySum);
    });

    return Container(
      child: StatisticsHistogram<int>(
        histogramName: GameCollectionLocalisations.of(context).timeLogsFieldString,
        domainLabels: GameCollectionLocalisations.of(context).shortDaysOfWeek,
        values: values,
        vertical: true,
        hideDomainLabels: false,
        labelAccessor: (String domainLabel, int value) => GameCollectionLocalisations.of(context).durationString(Duration(minutes: value)),
      ),
    );
  }*/

}