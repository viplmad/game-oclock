import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:game_collection_client/api.dart'
    show GameLogDTO;

import 'package:backend/model/model.dart'
    show CalendarRange, CalendarStyle, ItemFinish;
import 'package:backend/service/service.dart' show GameCollectionService;
import 'package:backend/bloc/calendar/single_calendar.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';
import 'package:backend/utils/duration_extension.dart';
import 'package:backend/utils/game_calendar_utils.dart';

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
    final GameCollectionService collectionService =
        RepositoryProvider.of<GameCollectionService>(context);

    final GameLogRelationManagerBloc gameLogRelationManagerBloc =
        GameLogRelationManagerBloc(
      itemId: itemId,
      collectionService: collectionService,
    );

    final GameFinishRelationManagerBloc finishRelationManagerBloc =
        GameFinishRelationManagerBloc(
      itemId: itemId,
      collectionService: collectionService,
    );

    final SingleCalendarBloc bloc = blocBuilder(
      collectionService,
      gameLogRelationManagerBloc,
      finishRelationManagerBloc,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<SingleCalendarBloc>(
          create: (BuildContext context) {
            return bloc..add(LoadSingleCalendar());
          },
        ),
        BlocProvider<GameLogRelationManagerBloc>(
          create: (BuildContext context) {
            return gameLogRelationManagerBloc;
          },
        ),
        BlocProvider<GameFinishRelationManagerBloc>(
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
              tooltip: GameCollectionLocalisations.of(context).firstGameLog,
              onPressed: () {
                bloc.add(UpdateSelectedDateFirst());
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_before),
              tooltip: GameCollectionLocalisations.of(context).previousGameLog,
              onPressed: () {
                bloc.add(UpdateSelectedDatePrevious());
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: GameCollectionLocalisations.of(context).nextGameLog,
              onPressed: () {
                bloc.add(UpdateSelectedDateNext());
              },
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              tooltip: GameCollectionLocalisations.of(context).lastGameLog,
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
          gameLogRelationManagerBloc,
          finishRelationManagerBloc,
        ),
      ),
    );
  }

  SingleCalendarBloc blocBuilder(
    GameCollectionService collectionService,
    GameLogRelationManagerBloc gameLogManagerBloc,
    GameFinishRelationManagerBloc gameFinishManagerBloc,
  ) {
    return SingleCalendarBloc(
      itemId: itemId,
      collectionService: collectionService,
      gameLogManagerBloc: gameLogManagerBloc,
      gameFinishManagerBloc: gameFinishManagerBloc,
    );
  }

  SpeedDial _buildSpeedDial(
    BuildContext context,
    GameLogRelationManagerBloc gameLogManagerBloc,
    GameFinishRelationManagerBloc gameFinishManagerBloc,
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
            GameCollectionLocalisations.of(context).gameLogFieldString,
          ),
          labelStyle: const TextStyle(color: Colors.white),
          labelBackgroundColor: Colors.grey[800],
          onTap: () async {
            Navigator.pushNamed<GameLogDTO?>(
              context,
              gameLogAssistantRoute,
            ).then((GameLogDTO? result) {
              if (result != null) {
                gameLogManagerBloc.add(
                  AddItemRelation<GameLogDTO>(
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
          onTap: () async {
            showGameDatePicker(
              context: context,
            ).then((DateTime? value) {
              if (value != null) {
                gameFinishManagerBloc.add(
                  AddItemRelation<ItemFinish>(ItemFinish(value)),
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
          BlocListener<GameLogRelationManagerBloc, ItemRelationManagerState>(
            listener: (BuildContext context, ItemRelationManagerState state) {
              if (state is ItemRelationAdded<GameLogDTO>) {
                _isUpdated = true;

                final String message =
                    GameCollectionLocalisations.of(context).addedString(
                  GameCollectionLocalisations.of(context).gameLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotAdded) {
                final String message =
                    GameCollectionLocalisations.of(context).unableToAddString(
                  GameCollectionLocalisations.of(context).gameLogFieldString,
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
                  GameCollectionLocalisations.of(context).gameLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotDeleted) {
                final String message = GameCollectionLocalisations.of(context)
                    .unableToDeleteString(
                  GameCollectionLocalisations.of(context).gameLogFieldString,
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
          BlocListener<GameFinishRelationManagerBloc, ItemRelationManagerState>(
            listener: (BuildContext context, ItemRelationManagerState state) {
              if (state is ItemRelationAdded<ItemFinish>) {
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
              Widget gameLogsWidget;
              if (state.selectedTotalTime.isZero()) {
                gameLogsWidget = Center(
                  child: Text(
                    GameCollectionLocalisations.of(context).emptyGameLogsString,
                  ),
                );
              } else {
                switch (state.style) {
                  case CalendarStyle.list:
                    gameLogsWidget = _buildGameLogsList(
                      context,
                      state.selectedGameLogs,
                      state.range,
                    );
                    break;
                  case CalendarStyle.graph:
                    gameLogsWidget = CalendarUtils.buildGameLogsGraph(
                      context,
                      state.selectedGameLogs,
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
                  Expanded(child: gameLogsWidget),
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
    List<DateTime> finishDates,
    DateTime selectedDate,
  ) {
    DateTime firstDate = DateTime.now();
    DateTime lastDate = firstDate;
    if (logDates.isNotEmpty) {
      firstDate = logDates.first;
      lastDate = logDates.last;
    }

    return CalendarUtils.buildTableCalendar(
      context,
      firstDay: firstDate,
      lastDay: lastDate,
      focusedDay: selectedDate,
      selectedDay: selectedDate,
      logDays: logDates,
      onDaySelected: (DateTime newSelectedDay) {
        BlocProvider.of<SingleCalendarBloc>(context).add(
          UpdateSelectedDate(
            newSelectedDay,
          ),
        );
      },
      finishes: finishDates,
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
          BlocProvider.of<GameFinishRelationManagerBloc>(context).add(
            DeleteItemRelation<ItemFinish>(ItemFinish(selectedDate)),
          );
        },
      ),
      tileColor: CalendarTheme.finishedColour,
    );
  }

  Widget _buildGameLogsList(
    BuildContext context,
    List<GameLogDTO> gameLogs,
    CalendarRange range,
  ) {
    final List<GameLogDTO> nonZeroGameLogs = gameLogs
        .where((GameLogDTO gameLog) => !gameLog.time.isZero())
        .toList(growable: false);

    return ItemListBuilder(
      itemCount: nonZeroGameLogs.length,
      itemBuilder: (BuildContext context, int index) {
        final GameLogDTO gameLog = nonZeroGameLogs.elementAt(index);
        final String durationString = GameCollectionLocalisations.of(context)
            .formatDuration(gameLog.time);

        if (range == CalendarRange.day) {
          final String gameLogString =
              '${GameCollectionLocalisations.of(context).formatTime(gameLog.datetime)} ⮕ ${GameCollectionLocalisations.of(context).formatTime(GameCalendarUtils.getEndDateTime(gameLog))} - $durationString';

          return DismissibleItem(
            dismissibleKey: gameLog.datetime.toString(),
            itemWidget: ListTile(
              title: Text(gameLogString),
              trailing: IconButton(
                icon: const Icon(Icons.link_off),
                onPressed: () {
                  BlocProvider.of<GameLogRelationManagerBloc>(context).add(
                    DeleteItemRelation<GameLogDTO>(
                      gameLog,
                    ),
                  );
                },
              ),
            ),
            onDismissed: (DismissDirection direction) {
              BlocProvider.of<GameLogRelationManagerBloc>(context).add(
                DeleteItemRelation<GameLogDTO>(
                  gameLog,
                ),
              );
            },
            dismissIcon: Icons.link_off,
          );
        } else {
          String rangeString = '';
          if (range == CalendarRange.week) {
            final int weekdayIndex =
                gameLog.datetime.weekday - 1; // Substract to use as index
            rangeString = GameCollectionLocalisations.of(context)
                .daysOfWeek
                .elementAt(weekdayIndex);
          } else if (range == CalendarRange.month) {
            rangeString = (gameLog.datetime.day).toString();
          } else if (range == CalendarRange.year) {
            final int monthIndex =
                gameLog.datetime.month - 1; // Substract to use as index
            rangeString = GameCollectionLocalisations.of(context)
                .months
                .elementAt(monthIndex);
          }
          final String gameLogString = '$rangeString - $durationString';

          return ListTile(
            title: Text(gameLogString),
          );
        }
      },
    );
  }
}
