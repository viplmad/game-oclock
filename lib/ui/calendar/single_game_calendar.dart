import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:game_oclock_client/api.dart' show GameLogDTO, NewGameLogDTO;

import 'package:logic/model/model.dart'
    show CalendarRange, CalendarStyle, ItemFinish;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/calendar/single_calendar.dart';
import 'package:logic/bloc/calendar_manager/calendar_manager.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';
import 'package:logic/utils/duration_extension.dart';

import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/skeleton.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/show_date_picker.dart';
import 'package:game_oclock/ui/utils/shape_utils.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show AppTheme, GameTheme, CalendarTheme;
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
    final GameOClockService collectionService =
        RepositoryProvider.of<GameOClockService>(context);

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
          // Fixed elevation so background colour doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(CalendarTheme.firstIcon),
              tooltip: AppLocalizations.of(context)!.firstLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateFirst());
              },
            ),
            IconButton(
              icon: const Icon(CalendarTheme.previousIcon),
              tooltip: AppLocalizations.of(context)!.previousLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDatePrevious());
              },
            ),
            IconButton(
              icon: const Icon(CalendarTheme.nextIcon),
              tooltip: AppLocalizations.of(context)!.nextLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateNext());
              },
            ),
            IconButton(
              icon: const Icon(CalendarTheme.lastIcon),
              tooltip: AppLocalizations.of(context)!.lastLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateLast());
              },
            ),
            PopupMenuButton<CalendarRange>(
              icon: const Icon(AppTheme.changeRangeIcon),
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
              icon: const Icon(CalendarTheme.changeStyleIcon),
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
    GameOClockService collectionService,
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
      icon: AppTheme.addIcon,
      activeIcon: AppTheme.closeIcon,
      shape: ShapeUtils.fabShapeBorder,
      tooltip: AppLocalizations.of(context)!.addString(
        AppLocalizations.of(context)!.gameCalendarEventString,
      ),
      overlayColor: Colors.black87,
      foregroundColor: Colors.white,
      backgroundColor: GameTheme.primaryColour,
      curve: Curves.bounceIn,
      overlayOpacity: 0.5,
      closeDialOnPop: true,
      children: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(GameTheme.sessionIcon, color: Colors.white),
          backgroundColor: GameTheme.primaryColour,
          shape: ShapeUtils.fabShapeBorder,
          label: AppLocalizations.of(context)!.addString(
            AppLocalizations.of(context)!.gameLogFieldString,
          ),
          labelStyle: const TextStyle(color: Colors.white),
          labelBackgroundColor: Colors.grey[800],
          onTap: () async {
            Navigator.pushNamed<NewGameLogDTO?>(
              context,
              gameLogAssistantRoute,
            ).then((NewGameLogDTO? result) {
              if (result != null) {
                gameLogManagerBloc.add(
                  AddItemRelation<NewGameLogDTO>(
                    result,
                  ),
                );
              }
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(GameTheme.finishedIcon, color: Colors.white),
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
                  AddItemRelation<DateTime>(value),
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
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (_changesMade && onChange != null) {
          onChange!();
        }
      },
      child: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<CalendarManagerBloc, CalendarManagerState>(
            listener: (BuildContext context, CalendarManagerState state) {
              if (state is CalendarNotLoaded) {
                final String message =
                    AppLocalizations.of(context)!.unableToLoadCalendarString;
                showApiErrorSnackbar(
                  context,
                  name: message,
                  error: state.error,
                  errorDescription: state.errorDescription,
                );
              }
            },
          ),
          BlocListener<GameLogRelationManagerBloc, ItemRelationManagerState>(
            listener: (BuildContext context, ItemRelationManagerState state) {
              if (state is ItemRelationAdded) {
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
                showApiErrorSnackbar(
                  context,
                  name: message,
                  error: state.error,
                  errorDescription: state.errorDescription,
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
                showApiErrorSnackbar(
                  context,
                  name: message,
                  error: state.error,
                  errorDescription: state.errorDescription,
                );
              }
            },
          ),
          BlocListener<GameFinishRelationManagerBloc, ItemRelationManagerState>(
            listener: (BuildContext context, ItemRelationManagerState state) {
              if (state is ItemRelationAdded) {
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
                showApiErrorSnackbar(
                  context,
                  name: message,
                  error: state.error,
                  errorDescription: state.errorDescription,
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
                showApiErrorSnackbar(
                  context,
                  name: message,
                  error: state.error,
                  errorDescription: state.errorDescription,
                );
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<SingleCalendarBloc>(context)
                .add(ReloadSingleCalendar());
          },
          child: BlocBuilder<SingleCalendarBloc, CalendarState>(
            builder: (BuildContext context, CalendarState state) {
              if (state is SingleCalendarLoaded) {
                Widget gameLogsWidget;
                if (state.selectedTotalTime.isZero()) {
                  gameLogsWidget = ListEmpty(
                    emptyTitle:
                        AppLocalizations.of(context)!.emptyPlayTimeString,
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
                    const ListDivider(),
                    ...(state.isSelectedDateFinish
                        ? <Widget>[
                            _buildFinishDate(context, state.selectedDate),
                            const ListDivider(),
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
                return ItemError(
                  title: AppLocalizations.of(context)!.somethingWentWrongString,
                  onRetryTap: () => BlocProvider.of<SingleCalendarBloc>(context)
                      .add(ReloadSingleCalendar()),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const LinearProgressIndicator(),
                  Skeleton(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  const ListDivider(),
                ],
              );
            },
          ),
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
      leading: const Icon(GameTheme.finishedIcon),
      title: Text(
        AppLocalizations.of(context)!.finishedThisDayString,
      ),
      trailing: IconButton(
        icon: const Icon(AppTheme.unlinkIcon),
        tooltip: AppLocalizations.of(context)!.deleteString,
        onPressed: () {
          BlocProvider.of<GameFinishRelationManagerBloc>(context).add(
            DeleteItemRelation<ItemFinish>(ItemFinish(selectedDate)),
          );
        },
      ),
      tileColor: GameTheme.finishedColour,
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
              '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(gameLog.startDatetime), alwaysUse24HourFormat: true)} ⮕ ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(gameLog.endDatetime), alwaysUse24HourFormat: true)} - $durationString';

          return ListTile(
            title: Text(gameLogString),
            trailing: IconButton(
              icon: const Icon(AppTheme.unlinkIcon),
              tooltip: AppLocalizations.of(context)!.deleteString,
              onPressed: () {
                BlocProvider.of<GameLogRelationManagerBloc>(context).add(
                  DeleteItemRelation<GameLogDTO>(
                    gameLog,
                  ),
                );
              },
            ),
          );
        } else {
          String rangeString = '';
          if (range == CalendarRange.week) {
            rangeString =
                AppLocalizationsUtils.formatWeekday(gameLog.startDatetime);
          } else if (range == CalendarRange.month) {
            rangeString =
                AppLocalizationsUtils.formatDay(gameLog.startDatetime);
          } else if (range == CalendarRange.year) {
            rangeString =
                AppLocalizationsUtils.formatMonth(gameLog.startDatetime);
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
