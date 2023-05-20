import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:game_collection_client/api.dart' show GameLogDTO;

import 'package:logic/model/model.dart'
    show CalendarRange, CalendarStyle, ItemFinish;
import 'package:logic/service/service.dart' show GameCollectionService;
import 'package:logic/bloc/calendar/single_calendar.dart';
import 'package:logic/bloc/calendar_manager/calendar_manager.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';
import 'package:logic/utils/duration_extension.dart';
import 'package:logic/utils/game_calendar_utils.dart';

import 'package:game_collection/ui/common/list_view.dart';
import 'package:game_collection/ui/common/skeleton.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';
import 'package:game_collection/ui/common/show_date_picker.dart';
import 'package:game_collection/ui/common/item_view.dart';
import 'package:game_collection/ui/utils/shape_utils.dart';
import 'package:game_collection/ui/utils/app_localizations_utils.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, CalendarTheme;
import 'calendar_utils.dart';

class SingleGameCalendar extends StatelessWidget {
  const SingleGameCalendar({
    Key? key,
    required this.itemId,
    this.onChange,
  }) : super(key: key);

  final String itemId;
  final void Function()? onChange;

  @override
  Widget build(BuildContext context) {
    final GameCollectionService collectionService =
        RepositoryProvider.of<GameCollectionService>(context);

    final CalendarManagerBloc managerBloc = CalendarManagerBloc();

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
      managerBloc,
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
        BlocProvider<CalendarManagerBloc>(
          create: (BuildContext context) {
            return managerBloc;
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
            AppLocalizations.of(context)!.calendarViewString,
          ),
          // Fixed elevation so background color doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.first_page),
              tooltip: AppLocalizations.of(context)!.firstLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateFirst());
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_before),
              tooltip: AppLocalizations.of(context)!.previousLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDatePrevious());
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: AppLocalizations.of(context)!.nextLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateNext());
              },
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              tooltip: AppLocalizations.of(context)!.lastLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateLast());
              },
            ),
            PopupMenuButton<CalendarRange>(
              icon: const Icon(Icons.date_range),
              tooltip: AppLocalizations.of(context)!.changeRangeString,
              itemBuilder: (BuildContext context) {
                return CalendarRange.values
                    .map<PopupMenuItem<CalendarRange>>((CalendarRange range) {
                  return PopupMenuItem<CalendarRange>(
                    value: range,
                    child: ListTile(
                      title: Text(
                        CalendarUtils.rangeString(context, range),
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
              tooltip: AppLocalizations.of(context)!.changeStyleString,
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
    CalendarManagerBloc managerBloc,
    GameLogRelationManagerBloc gameLogManagerBloc,
    GameFinishRelationManagerBloc gameFinishManagerBloc,
  ) {
    return SingleCalendarBloc(
      itemId: itemId,
      collectionService: collectionService,
      managerBloc: managerBloc,
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
      tooltip: AppLocalizations.of(context)!.addString(
        AppLocalizations.of(context)!.gameCalendarEventsString,
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
          label: AppLocalizations.of(context)!.addString(
            AppLocalizations.of(context)!.gameLogFieldString,
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
          label: AppLocalizations.of(context)!.addString(
            AppLocalizations.of(context)!.finishDateFieldString,
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
      onChange: onChange,
    );
  }
}

// ignore: must_be_immutable
class _SingleGameCalendarBody extends StatelessWidget {
  _SingleGameCalendarBody({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  final void Function()? onChange;

  bool _changesMade = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_changesMade && onChange != null) {
          onChange!();
        }
        return true;
      },
      child: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<CalendarManagerBloc, CalendarManagerState>(
            listener: (BuildContext context, CalendarManagerState state) {
              if (state is CalendarNotLoaded) {
                final String message =
                    AppLocalizations.of(context)!.unableToLoadCalendar;
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: AppLocalizations.of(context)!.moreString,
                    title: message,
                    content: state.error,
                  ),
                );
              }
            },
          ),
          BlocListener<GameLogRelationManagerBloc, ItemRelationManagerState>(
            listener: (BuildContext context, ItemRelationManagerState state) {
              if (state is ItemRelationAdded<GameLogDTO>) {
                _changesMade = true;

                final String message =
                    AppLocalizations.of(context)!.addedString(
                  AppLocalizations.of(context)!.gameLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotAdded) {
                final String message =
                    AppLocalizations.of(context)!.unableToAddString(
                  AppLocalizations.of(context)!.gameLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: AppLocalizations.of(context)!.moreString,
                    title: message,
                    content: state.error,
                  ),
                );
              }
              if (state is ItemRelationDeleted) {
                _changesMade = true;

                final String message =
                    AppLocalizations.of(context)!.deletedString(
                  AppLocalizations.of(context)!.gameLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotDeleted) {
                final String message =
                    AppLocalizations.of(context)!.unableToDeleteString(
                  AppLocalizations.of(context)!.gameLogFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: AppLocalizations.of(context)!.moreString,
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
                _changesMade = true;

                final String message =
                    AppLocalizations.of(context)!.addedString(
                  AppLocalizations.of(context)!.finishDateFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotAdded) {
                final String message =
                    AppLocalizations.of(context)!.unableToAddString(
                  AppLocalizations.of(context)!.finishDateFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: AppLocalizations.of(context)!.moreString,
                    title: message,
                    content: state.error,
                  ),
                );
              }
              if (state is ItemRelationDeleted) {
                _changesMade = true;

                final String message =
                    AppLocalizations.of(context)!.deletedString(
                  AppLocalizations.of(context)!.finishDateFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if (state is ItemRelationNotDeleted) {
                final String message =
                    AppLocalizations.of(context)!.unableToDeleteString(
                  AppLocalizations.of(context)!.finishDateFieldString,
                );
                showSnackBar(
                  context,
                  message: message,
                  snackBarAction: dialogSnackBarAction(
                    context,
                    label: AppLocalizations.of(context)!.moreString,
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
                    AppLocalizations.of(context)!.emptyPlayTime,
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
                            AppLocalizationsUtils.formatDuration(
                              context,
                              state.selectedTotalTime,
                            ),
                          )
                        : null,
                  ),
                  Expanded(child: gameLogsWidget),
                ],
              );
            }
            if (state is CalendarError) {
              return Container();
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
        AppLocalizations.of(context)!.selectedDateIsFinishDateString,
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
        final String durationString =
            AppLocalizationsUtils.formatDuration(context, gameLog.time);

        if (range == CalendarRange.day) {
          final String gameLogString =
              '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(gameLog.datetime), alwaysUse24HourFormat: true)} ⮕ ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(GameCalendarUtils.getEndDateTime(gameLog)), alwaysUse24HourFormat: true)} - $durationString';

          return DismissibleItem(
            dismissibleKey: gameLog.datetime.millisecondsSinceEpoch.toString(),
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
            rangeString = AppLocalizationsUtils.formatWeekday(gameLog.datetime);
          } else if (range == CalendarRange.month) {
            rangeString = AppLocalizationsUtils.formatDay(gameLog.datetime);
          } else if (range == CalendarRange.year) {
            rangeString = AppLocalizationsUtils.formatMonth(gameLog.datetime);
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
