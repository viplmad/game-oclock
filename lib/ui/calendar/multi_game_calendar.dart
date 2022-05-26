import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart' as table_calendar;

import 'package:backend/model/model.dart' show Game, GameWithLogs;
import 'package:backend/model/calendar_range.dart';

import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/calendar/multi_calendar.dart';

import 'package:backend/utils/datetime_extension.dart';
import 'package:backend/utils/duration_extension.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/list_view.dart';
import '../common/skeleton.dart';
import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, CalendarTheme;
import '../detail/detail_arguments.dart';
import 'calendar_utils.dart';

class MultiGameCalendar extends StatelessWidget {
  const MultiGameCalendar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MultiCalendarBloc bloc = MultiCalendarBloc(
      collectionRepository:
          RepositoryProvider.of<GameCollectionRepository>(context),
    );

    return BlocProvider<MultiCalendarBloc>(
      create: (BuildContext context) {
        return bloc..add(LoadMultiCalendar(DateTime.now().year));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            GameCollectionLocalisations.of(context).multiCalendarViewString,
          ),
          // Fixed elevation so background color doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.first_page),
              tooltip: GameCollectionLocalisations.of(context).firstTimeLog,
              onPressed: () {
                bloc.add(UpdateSelectedDateFirst());
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_before),
              tooltip: GameCollectionLocalisations.of(context).previousTimeLog,
              onPressed: () {
                bloc.add(UpdateSelectedDatePrevious());
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: GameCollectionLocalisations.of(context).nextTimeLog,
              onPressed: () {
                bloc.add(UpdateSelectedDateNext());
              },
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              tooltip: GameCollectionLocalisations.of(context).lastTimeLog,
              onPressed: () {
                bloc.add(UpdateSelectedDateLast());
              },
            ),
            PopupMenuButton<CalendarRange>(
              icon: const Icon(Icons.date_range),
              tooltip:
                  GameCollectionLocalisations.of(context).changeRangeString,
              itemBuilder: (BuildContext context) {
                return CalendarRange.values
                    .map<PopupMenuItem<CalendarRange>>((CalendarRange range) {
                  return PopupMenuItem<CalendarRange>(
                    value: range,
                    child: ListTile(
                      title: Text(
                        GameCollectionLocalisations.of(context)
                            .rangeString(range),
                      ),
                    ),
                  );
                }).toList(growable: false);
              },
              onSelected: (CalendarRange range) {
                bloc.add(UpdateCalendarRange(range));
              },
            ),
            IconButton(
              icon: const Icon(Icons.insert_chart),
              tooltip:
                  GameCollectionLocalisations.of(context).changeStyleString,
              onPressed: () {
                bloc.add(UpdateCalendarStyle());
              },
            ),
          ],
        ),
        body: bodyBuilder(),
      ),
    );
  }

  // ignore: library_private_types_in_public_api
  _MultiGameCalendarBody bodyBuilder() {
    return const _MultiGameCalendarBody();
  }
}

class _MultiGameCalendarBody extends StatelessWidget {
  const _MultiGameCalendarBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiCalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        if (state is MultiCalendarLoaded) {
          Widget timeLogsWidget;
          if (state.selectedTotalTime.isZero()) {
            timeLogsWidget = Center(
              child: Text(
                GameCollectionLocalisations.of(context).emptyTimeLogsString,
              ),
            );
          } else {
            if (state is MultiCalendarGraphLoaded) {
              timeLogsWidget = CalendarUtils.buildTimeLogsGraph(
                context,
                state.selectedTimeLogs,
                state.range,
              );
            } else {
              timeLogsWidget =
                  _buildTimeLogsList(context, state.selectedGamesWithLogs);
            }
          }

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildTableCalendar(
                context,
                state.logDates,
                state.focusedDate,
                state.selectedDate,
              ),
              const Divider(height: 4.0),
              ListTile(
                title: Text(
                  CalendarUtils.titleString(
                    context,
                    state.selectedDate,
                    state.range,
                  ),
                ),
                trailing: !state.selectedTotalTime.isZero()
                    ? Text(
                        '${GameCollectionLocalisations.of(context).totalGames(state.selectedTotalGames)} / ${GameCollectionLocalisations.of(context).formatDuration(state.selectedTotalTime)}',
                      )
                    : null,
              ),
              Expanded(child: timeLogsWidget),
            ],
          );
        }
        if (state is CalendarNotLoaded) {
          return Center(
            child: Text(state.error),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const LinearProgressIndicator(),
            Skeleton(
              height: MediaQuery.of(context).size.height / 2.5,
            ),
            const Divider(height: 4.0),
          ],
        );
      },
    );
  }

  Widget _buildTableCalendar(
    BuildContext context,
    Set<DateTime> logDates,
    DateTime focusedDate,
    DateTime selectedDate,
  ) {
    DateTime lastDate = DateTime.now();
    if (logDates.isNotEmpty) {
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
        return logDates
            .where((DateTime logDate) => date.isSameDay(logDate))
            .toList(growable: false);
      },
      startingDayOfWeek: table_calendar.StartingDayOfWeek.monday,
      weekendDays: const <int>[DateTime.saturday, DateTime.sunday],
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
          color: CalendarTheme.todayColour,
          shape: CalendarTheme.shape,
        ),
        selectedDecoration: const BoxDecoration(
          color: CalendarTheme.selectedColour,
          shape: CalendarTheme.shape,
        ),

        ///EVENTS
        markersMaxCount: 1,
        markersAlignment: Alignment.bottomRight,
        markerSizeScale: 0.35,
        markerDecoration: const BoxDecoration(
          color: CalendarTheme.playedColour,
          shape: CalendarTheme.shape,
        ),

        ///HOLIDAY
        holidayDecoration: const BoxDecoration(
          color: CalendarTheme.finishedColour,
          shape: CalendarTheme.shape,
        ),
        holidayTextStyle: const TextStyle(color: Color(0xFF5A5A5A)),

        ///WEEKEND
        weekendDecoration: BoxDecoration(
          color: CalendarTheme.weekendColour,
          shape: CalendarTheme.shape,
        ),
        weekendTextStyle: const TextStyle(color: Color(0xFF5A5A5A)),
      ),
    );
  }

  Widget _buildTimeLogsList(
    BuildContext context,
    List<GameWithLogs> gamesWithLogs,
  ) {
    return ItemListBuilder(
      itemCount: gamesWithLogs.length,
      itemBuilder: (BuildContext context, int index) {
        final GameWithLogs gameWithLogs = gamesWithLogs.elementAt(index);

        return GameTheme.itemCardWithTime(
          context,
          gameWithLogs.game,
          gameWithLogs.totalTime,
          onTap,
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
            if (updatedItem != null) {
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
