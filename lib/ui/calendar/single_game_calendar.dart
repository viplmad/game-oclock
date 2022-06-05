import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart' as table_calendar;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:backend/model/model.dart' show GameTimeLog, GameFinish;
import 'package:backend/model/calendar_range.dart';
import 'package:backend/model/calendar_style.dart';

import 'package:backend/repository/repository.dart';

import 'package:backend/bloc/calendar/single_calendar.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:backend/utils/datetime_extension.dart';
import 'package:backend/utils/duration_extension.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/list_view.dart';
import '../common/skeleton.dart';
import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, CalendarTheme;
import '../common/show_snackbar.dart';
import '../common/show_date_picker.dart';
import '../common/item_view.dart';
import '../utils/shape_utils.dart';
import 'calendar_utils.dart';

class SingleGameCalendar extends StatelessWidget {
  const SingleGameCalendar({
    Key? key,
    required this.itemId,
    this.onUpdate,
  }) : super(key: key);

  final int itemId;
  final void Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    final GameCollectionRepository collectionRepository =
        RepositoryProvider.of<GameCollectionRepository>(context);

    final GameRelationManagerBloc<GameTimeLog> timeLogRelationManagerBloc =
        GameRelationManagerBloc<GameTimeLog>(
      itemId: itemId,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<GameFinish> finishRelationManagerBloc =
        GameRelationManagerBloc<GameFinish>(
      itemId: itemId,
      collectionRepository: collectionRepository,
    );

    final SingleCalendarBloc bloc = blocBuilder(
      collectionRepository,
      timeLogRelationManagerBloc,
      finishRelationManagerBloc,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<SingleCalendarBloc>(
          create: (BuildContext context) {
            return bloc..add(LoadSingleCalendar());
          },
        ),
        BlocProvider<GameRelationManagerBloc<GameTimeLog>>(
          create: (BuildContext context) {
            return timeLogRelationManagerBloc;
          },
        ),
        BlocProvider<GameRelationManagerBloc<GameFinish>>(
          create: (BuildContext context) {
            return finishRelationManagerBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            GameCollectionLocalisations.of(context).singleCalendarViewString,
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
        floatingActionButton: _buildSpeedDial(
          context,
          timeLogRelationManagerBloc,
          finishRelationManagerBloc,
        ),
      ),
    );
  }

  SingleCalendarBloc blocBuilder(
    GameCollectionRepository collectionRepository,
    GameRelationManagerBloc<GameTimeLog> timeLogManagerBloc,
    GameRelationManagerBloc<GameFinish> finishDateManagerBloc,
  ) {
    return SingleCalendarBloc(
      itemId: itemId,
      collectionRepository: collectionRepository,
      timeLogManagerBloc: timeLogManagerBloc,
      finishDateManagerBloc: finishDateManagerBloc,
    );
  }

  SpeedDial _buildSpeedDial(
    BuildContext context,
    GameRelationManagerBloc<GameTimeLog> timeLogManagerBloc,
    GameRelationManagerBloc<GameFinish> finishDateManagerBloc,
  ) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.remove,
      shape: ShapeUtils.fabShapeBorder,
      tooltip: GameCollectionLocalisations.of(context).addString(
        GameCollectionLocalisations.of(context).gameCalendarEventsString,
      ),
      overlayColor: Colors.black87,
      foregroundColor: Colors.white,
      backgroundColor: GameTheme.primaryColour,
      curve: Curves.bounceIn,
      overlayOpacity: 0.5,
      closeDialOnPop: true,
      children: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.add_alarm, color: Colors.white),
          backgroundColor: GameTheme.primaryColour,
          shape: ShapeUtils.fabShapeBorder,
          label: GameCollectionLocalisations.of(context).addString(
            GameCollectionLocalisations.of(context).timeLogFieldString,
          ),
          labelStyle: const TextStyle(color: Colors.white),
          labelBackgroundColor: Colors.grey[800],
          onTap: () {
            Navigator.pushNamed<GameTimeLog?>(
              context,
              timeLogAssistantRoute,
            ).then((GameTimeLog? result) {
              if (result != null) {
                timeLogManagerBloc.add(
                  AddItemRelation<GameTimeLog>(
                    result,
                  ),
                );
              }
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.event_available, color: Colors.white),
          backgroundColor: GameTheme.primaryColour,
          shape: ShapeUtils.fabShapeBorder,
          label: GameCollectionLocalisations.of(context).addString(
            GameCollectionLocalisations.of(context).finishDateFieldString,
          ),
          labelStyle: const TextStyle(color: Colors.white),
          labelBackgroundColor: Colors.grey[800],
          onTap: () {
            showGameDatePicker(
              context: context,
            ).then((DateTime? value) {
              if (value != null) {
                finishDateManagerBloc.add(
                  AddItemRelation<GameFinish>(
                    GameFinish(dateTime: value),
                  ),
                );
              }
            });
          },
        ),
      ],
    );
  }

  // ignore: library_private_types_in_public_api
  _SingleGameCalendarBody bodyBuilder() {
    return _SingleGameCalendarBody(
      onUpdate: onUpdate,
    );
  }
}

// ignore: must_be_immutable
class _SingleGameCalendarBody extends StatelessWidget {
  _SingleGameCalendarBody({
    Key? key,
    required this.onUpdate,
  }) : super(key: key);

  final void Function()? onUpdate;

  bool _isUpdated = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isUpdated && onUpdate != null) {
          onUpdate!();
        }
        return true;
      },
      child: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<GameRelationManagerBloc<GameTimeLog>,
              ItemRelationManagerState>(
            listener: (BuildContext context, ItemRelationManagerState state) {
              if (state is ItemRelationAdded<GameTimeLog>) {
                _isUpdated = true;

                final String message =
                    GameCollectionLocalisations.of(context).addedString(
                  GameCollectionLocalisations.of(context).timeLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotAdded) {
                final String message =
                    GameCollectionLocalisations.of(context).unableToAddString(
                  GameCollectionLocalisations.of(context).timeLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: GameCollectionLocalisations.of(context).moreString,
                    title: message,
                    content: state.error,
                  ),
                );
              }
              if (state is ItemRelationDeleted) {
                _isUpdated = true;

                final String message =
                    GameCollectionLocalisations.of(context).deletedString(
                  GameCollectionLocalisations.of(context).timeLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotDeleted) {
                final String message = GameCollectionLocalisations.of(context)
                    .unableToDeleteString(
                  GameCollectionLocalisations.of(context).timeLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: GameCollectionLocalisations.of(context).moreString,
                    title: message,
                    content: state.error,
                  ),
                );
              }
            },
          ),
          BlocListener<GameRelationManagerBloc<GameFinish>,
              ItemRelationManagerState>(
            listener: (BuildContext context, ItemRelationManagerState state) {
              if (state is ItemRelationAdded<GameFinish>) {
                _isUpdated = true;

                final String message =
                    GameCollectionLocalisations.of(context).addedString(
                  GameCollectionLocalisations.of(context).finishDateFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotAdded) {
                final String message =
                    GameCollectionLocalisations.of(context).unableToAddString(
                  GameCollectionLocalisations.of(context).finishDateFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: GameCollectionLocalisations.of(context).moreString,
                    title: message,
                    content: state.error,
                  ),
                );
              }
              if (state is ItemRelationDeleted) {
                _isUpdated = true;

                final String message =
                    GameCollectionLocalisations.of(context).deletedString(
                  GameCollectionLocalisations.of(context).finishDateFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotDeleted) {
                final String message = GameCollectionLocalisations.of(context)
                    .unableToDeleteString(
                  GameCollectionLocalisations.of(context).finishDateFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: GameCollectionLocalisations.of(context).moreString,
                    title: message,
                    content: state.error,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<SingleCalendarBloc, CalendarState>(
          builder: (BuildContext context, CalendarState state) {
            if (state is SingleCalendarLoaded) {
              Widget timeLogsWidget;
              if (state.selectedTotalTime.isZero()) {
                timeLogsWidget = Center(
                  child: Text(
                    GameCollectionLocalisations.of(context).emptyTimeLogsString,
                  ),
                );
              } else {
                switch (state.style) {
                  case CalendarStyle.list:
                    timeLogsWidget = _buildTimeLogsList(
                      context,
                      state.selectedTimeLogs,
                      state.range,
                    );
                    break;
                  case CalendarStyle.graph:
                    timeLogsWidget = CalendarUtils.buildTimeLogsGraph(
                      context,
                      state.selectedTimeLogs,
                      state.range,
                    );
                    break;
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildTableCalendar(
                    context,
                    state.logDates,
                    state.finishDates,
                    state.selectedDate,
                  ),
                  const Divider(height: 4.0),
                  ...(state.isSelectedDateFinish
                      ? <Widget>[
                          _buildFinishDate(context, state.selectedDate),
                          const Divider(height: 4.0),
                        ]
                      : <Widget>[]),
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
                            GameCollectionLocalisations.of(context)
                                .formatDuration(state.selectedTotalTime),
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
        ),
      ),
    );
  }

  Widget _buildTableCalendar(
    BuildContext context,
    Set<DateTime> logDates,
    List<GameFinish> finishDates,
    DateTime selectedDate,
  ) {
    DateTime firstDate = DateTime.now();
    DateTime lastDate = firstDate;
    if (logDates.isNotEmpty) {
      firstDate = logDates.first;
      lastDate = logDates.last;
    }

    return table_calendar.TableCalendar<DateTime>(
      firstDay: firstDate,
      lastDay: lastDate,
      focusedDay: selectedDate,
      selectedDayPredicate: (DateTime day) {
        return day.isSameDay(selectedDate);
      },
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        BlocProvider.of<SingleCalendarBloc>(context).add(
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
      holidayPredicate: (DateTime date) {
        return finishDates
            .any((GameFinish finish) => date.isSameDay(finish.dateTime));
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

  Widget _buildFinishDate(BuildContext context, DateTime selectedDate) {
    return ListTile(
      title: Text(
        GameCollectionLocalisations.of(context).selectedDateIsFinishDateString,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.link_off),
        onPressed: () {
          BlocProvider.of<GameRelationManagerBloc<GameFinish>>(context).add(
            DeleteItemRelation<GameFinish>(
              GameFinish(dateTime: selectedDate),
            ),
          );
        },
      ),
      tileColor: CalendarTheme.finishedColour,
    );
  }

  Widget _buildTimeLogsList(
    BuildContext context,
    List<GameTimeLog> timeLogs,
    CalendarRange range,
  ) {
    return ItemListBuilder(
      itemCount: timeLogs.length,
      itemBuilder: (BuildContext context, int index) {
        final GameTimeLog timeLog = timeLogs.elementAt(index);
        final String durationString = GameCollectionLocalisations.of(context)
            .formatDuration(timeLog.time);

        if (timeLog.time.isZero()) {
          return Container();
        }

        if (range == CalendarRange.day) {
          final String timeLogString =
              '${GameCollectionLocalisations.of(context).formatTime(timeLog.dateTime)} ⮕ ${GameCollectionLocalisations.of(context).formatTime(timeLog.endDateTime)} - $durationString';

          return DismissibleItem(
            dismissibleKey: timeLog.uniqueId,
            itemWidget: ListTile(
              title: Text(timeLogString),
              trailing: IconButton(
                icon: const Icon(Icons.link_off),
                onPressed: () {
                  BlocProvider.of<GameRelationManagerBloc<GameTimeLog>>(context)
                      .add(
                    DeleteItemRelation<GameTimeLog>(
                      timeLog,
                    ),
                  );
                },
              ),
            ),
            onDismissed: (DismissDirection direction) {
              BlocProvider.of<GameRelationManagerBloc<GameTimeLog>>(context)
                  .add(
                DeleteItemRelation<GameTimeLog>(
                  timeLog,
                ),
              );
            },
            dismissIcon: Icons.link_off,
          );
        } else {
          String rangeString = '';
          if (range == CalendarRange.week) {
            rangeString = GameCollectionLocalisations.of(context)
                .daysOfWeek
                .elementAt(index);
          } else if (range == CalendarRange.month) {
            rangeString = index.toString();
          } else if (range == CalendarRange.year) {
            rangeString =
                GameCollectionLocalisations.of(context).months.elementAt(index);
          }
          final String timeLogString = '$rangeString - $durationString';

          return ListTile(
            title: Text(timeLogString),
          );
        }
      },
    );
  }
}
