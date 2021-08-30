import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart' as table_calendar;

import 'package:backend/model/model.dart' show Game, GameWithLogs;
import 'package:backend/model/calendar_range.dart';
import 'package:backend/model/calendar_style.dart';

import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/calendar/multi_calendar.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import '../common/loading_icon.dart';
import '../detail/detail.dart';
import 'calendar_utils.dart';


class MultiGameCalendar extends StatelessWidget {
  const MultiGameCalendar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MultiCalendarBloc _bloc = MultiCalendarBloc(
      collectionRepository: RepositoryProvider.of<GameCollectionRepository>(context),
    );

    return BlocProvider<MultiCalendarBloc>(
      create: (BuildContext context) {
        return _bloc..add(LoadMultiCalendar(DateTime.now().year));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(GameCollectionLocalisations.of(context).multiCalendarViewString),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.first_page),
              tooltip: GameCollectionLocalisations.of(context).firstTimeLog,
              onPressed: () {
                _bloc.add(UpdateSelectedDateFirst());
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_before),
              tooltip: GameCollectionLocalisations.of(context).previousTimeLog,
              onPressed: () {
                _bloc.add(UpdateSelectedDatePrevious());
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: GameCollectionLocalisations.of(context).nextTimeLog,
              onPressed: () {
                _bloc.add(UpdateSelectedDateNext());
              },
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              tooltip: GameCollectionLocalisations.of(context).lastTimeLog,
              onPressed: () {
                _bloc.add(UpdateSelectedDateLast());
              },
            ),
            PopupMenuButton<CalendarRange>(
              icon: const Icon(Icons.date_range),
              tooltip: GameCollectionLocalisations.of(context).changeRangeString,
              itemBuilder: (BuildContext context) {
                return CalendarRange.values.map<PopupMenuItem<CalendarRange>>( (CalendarRange range) {
                  return PopupMenuItem<CalendarRange>(
                    child: ListTile(
                      title: Text(GameCollectionLocalisations.of(context).rangeString(range)),
                    ),
                    value: range,
                  );
                }).toList(growable: false);
              },
              onSelected: (CalendarRange range) {
                _bloc.add(
                  UpdateCalendarRange(range)
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.insert_chart),
              tooltip: GameCollectionLocalisations.of(context).changeStyleString,
              onPressed: () {
                _bloc.add(UpdateCalendarStyle());
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

    return BlocBuilder<MultiCalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {

        if(state is MultiCalendarLoaded) {
          Widget timeLogsWidget = Container();
          if(state is MultiCalendarListLoaded) {
            timeLogsWidget = _buildTimeLogsList(context, state.selectedGamesWithLogs);
          } else if(state is MultiCalendarGraphLoaded) {
            timeLogsWidget = CalendarUtils.buildTimeLogsGraph(context, state.selectedTimeLogs, state.range);
          }

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildTableCalendar(context, state.logDates, state.focusedDate, state.selectedDate),
              const Divider(height: 4.0),
              ListTile(
                title: Text(GameCollectionLocalisations.of(context).timeLogsFieldString + ' - ' + GameCollectionLocalisations.of(context).dateString(state.selectedDate) + ((state.range == CalendarRange.Day && state.style == CalendarStyle.List)? '' : ' (' + GameCollectionLocalisations.of(context).rangeString(state.range) + ')')),
                trailing: Text(GameCollectionLocalisations.of(context).durationString(state.selectedTotalTime)),
              ),
              Expanded(child: timeLogsWidget),
            ],
          );

        }
        if(state is CalendarNotLoaded) {

          return Center(
            child: Text(state.error),
          );

        }

        return const LoadingIcon();

      },
    );

  }

  Widget _buildTableCalendar(BuildContext context, Set<DateTime> logDates, DateTime focusedDate, DateTime selectedDate) {
    DateTime lastDate = DateTime.now();
    if(logDates.isNotEmpty) {
      lastDate = logDates.last;
    }

    return table_calendar.TableCalendar<DateTime>(
      firstDay: DateTime(1970),
      lastDay: lastDate,
      focusedDay: focusedDate,
      selectedDayPredicate: (DateTime day) {
        return day.isSameDay(selectedDate);
      },
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        BlocProvider.of<MultiCalendarBloc>(context).add(
          UpdateSelectedDate(
            selectedDay,
          ),
        );
      },
      eventLoader: (DateTime date) {
        return logDates.where((DateTime logDate) => date.isSameDay(logDate)).toList(growable: false);
      },
      startingDayOfWeek: table_calendar.StartingDayOfWeek.monday,
      weekendDays: const <int>[
        DateTime.saturday,
        DateTime.sunday
      ],
      pageJumpingEnabled: true,
      availableGestures: table_calendar.AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const <table_calendar.CalendarFormat, String>{
        table_calendar.CalendarFormat.month: '',
      },
      headerStyle: const table_calendar.HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      onPageChanged: (DateTime date) {
        BlocProvider.of<MultiCalendarBloc>(context).add(
          LoadMultiCalendar(
            date.year,
          ),
        );
      },
      rowHeight: 65.0,
      calendarStyle: table_calendar.CalendarStyle(
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
        holidayTextStyle: const TextStyle(color: Color(0xFF5A5A5A)),
        ///WEEKEND
        weekendDecoration: BoxDecoration(
          color: Colors.grey.withAlpha(50),
          shape: BoxShape.circle,
        ),
        weekendTextStyle: const TextStyle(color: Color(0xFF5A5A5A)),
      ),
    );
  }

  Widget _buildTimeLogsList(BuildContext context, List<GameWithLogs> gamesWithLogs) {

    if(gamesWithLogs.isEmpty) {
      return Center(
        child: Text(GameCollectionLocalisations.of(context).emptyTimeLogsString),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: gamesWithLogs.length,
      itemBuilder: (BuildContext context, int index) {
        final GameWithLogs gameWithLogs = gamesWithLogs.elementAt(index);

        return Padding(
          padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
          child: GameTheme.itemCardWithTime(context, gameWithLogs.game, gameWithLogs.totalTime, onTap),
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
          onUpdate: (Game? updatedItem) {

            if(updatedItem != null) {

              BlocProvider.of<MultiCalendarBloc>(context).add(
                UpdateCalendarListItem(
                  updatedItem,
                ),
              );

            }

          },
        ),
      );
    };

  }

}