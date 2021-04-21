import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart' as table_calendar;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/calendar/single_calendar.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart';
import '../common/loading_icon.dart';
import '../common/show_snackbar.dart';
import '../common/show_date_picker.dart';
import '../common/statistics_histogram.dart';
import '../common/duration_picker_dialog.dart';
import '../common/item_view.dart';


class SingleGameCalendarArguments {
  const SingleGameCalendarArguments({
    required this.itemId,
    this.onUpdate,
  });

  final int itemId;
  final void Function()? onUpdate;
}

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

    final GameTimeLogRelationManagerBloc _timeLogRelationManagerBloc = GameTimeLogRelationManagerBloc(
      itemId: itemId,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final GameFinishDateRelationManagerBloc _finishRelationManagerBloc = GameFinishDateRelationManagerBloc(
      itemId: itemId,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final SingleCalendarBloc _bloc = blocBuilder(_timeLogRelationManagerBloc, _finishRelationManagerBloc);

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<SingleCalendarBloc>(
          create: (BuildContext context) {
            return _bloc..add(LoadCalendar());
          },
        ),

        BlocProvider<GameTimeLogRelationManagerBloc>(
          create: (BuildContext context) {
            return _timeLogRelationManagerBloc;
          },
        ),
        BlocProvider<GameFinishDateRelationManagerBloc>(
          create: (BuildContext context) {
            return _finishRelationManagerBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(GameCollectionLocalisations.of(context).singleCalendarViewString),
          actions: <IconButton>[
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
            IconButton(
              icon: const Icon(Icons.insert_chart),
              tooltip: GameCollectionLocalisations.of(context).changeStyleString,
              onPressed: () {
                _bloc.add(UpdateStyle());
              },
            ),
          ],
        ),
        body: bodyBuilder(),
        floatingActionButton: _buildSpeedDial(context, _timeLogRelationManagerBloc, _finishRelationManagerBloc),
      ),
    );

  }

  SingleCalendarBloc blocBuilder(GameTimeLogRelationManagerBloc timeLogManagerBloc, GameFinishDateRelationManagerBloc finishDateManagerBloc) {

    return SingleCalendarBloc(
      itemId: itemId,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
      timeLogManagerBloc: timeLogManagerBloc,
      finishDateManagerBloc: finishDateManagerBloc,
    );

  }

  SpeedDial _buildSpeedDial(BuildContext context, GameTimeLogRelationManagerBloc timeLogManagerBloc, GameFinishDateRelationManagerBloc finishDateManagerBloc) {

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.remove,
      tooltip: GameCollectionLocalisations.of(context).addString(GameCollectionLocalisations.of(context).gameCalendarEventsString),
      overlayColor: Colors.black87,
      backgroundColor: GameTheme.primaryColour,
      curve: Curves.bounceIn,
      overlayOpacity: 0.5,
      children: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.add_alarm),
          label: GameCollectionLocalisations.of(context).addString(GameCollectionLocalisations.of(context).timeLogFieldString),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: GameTheme.primaryColour,
          onTap: () {

            showGameDatePicker(
              context: context,
            ).then((DateTime? date) {
              if(date != null) {

                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((TimeOfDay? time) {
                  if(time != null) {

                    showDialog<Duration>(
                      context: context,
                      builder: (BuildContext context) {

                        return DurationPickerDialog(
                          fieldName: GameCollectionLocalisations.of(context).editTimeString,
                          initialDuration: Duration.zero,
                        );

                      },
                    ).then((Duration? duration) {
                      if(duration != null) {

                        final DateTime dateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );

                        timeLogManagerBloc.add(
                          AddRelation<TimeLog>(
                            TimeLog(dateTime: dateTime, time: duration),
                          ),
                        );

                      }
                    });

                  }
                });

              }
            });

          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.event_available),
          label: GameCollectionLocalisations.of(context).addString(GameCollectionLocalisations.of(context).finishDateFieldString),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: GameTheme.primaryColour,
          onTap: () {

            showGameDatePicker(
              context: context,
            ).then((DateTime? value) {
              if(value != null) {
                finishDateManagerBloc.add(
                  AddRelation<DateTime>(value),
                );
              }
            });

          },
        ),
      ],
    );

  }

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
      onWillPop: () {

        if(_isUpdated && onUpdate != null) { onUpdate!(); }
        return Future<bool>.value(true);

      },
      child: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<GameTimeLogRelationManagerBloc, RelationManagerState>(
            listener: (BuildContext context, RelationManagerState state) {
              if(state is RelationAdded<TimeLog>) {
                _isUpdated = true;

                final String message = GameCollectionLocalisations.of(context).addedString(GameCollectionLocalisations.of(context).timeLogFieldString);
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if(state is RelationNotAdded) {
                final String message = GameCollectionLocalisations.of(context).unableToAddString(GameCollectionLocalisations.of(context).timeLogFieldString);
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
              if(state is RelationDeleted) {
                _isUpdated = true;

                final String message = GameCollectionLocalisations.of(context).deletedString(GameCollectionLocalisations.of(context).timeLogFieldString);
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if(state is RelationNotDeleted) {
                final String message = GameCollectionLocalisations.of(context).unableToDeleteString(GameCollectionLocalisations.of(context).timeLogFieldString);
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
          BlocListener<GameFinishDateRelationManagerBloc, RelationManagerState>(
            listener: (BuildContext context, RelationManagerState state) {
              if(state is RelationAdded<DateTime>) {
                _isUpdated = true;

                final String message = GameCollectionLocalisations.of(context).addedString(GameCollectionLocalisations.of(context).finishDateFieldString);
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if(state is RelationNotAdded) {
                final String message = GameCollectionLocalisations.of(context).unableToAddString(GameCollectionLocalisations.of(context).finishDateFieldString);
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
              if(state is RelationDeleted) {
                _isUpdated = true;

                final String message = GameCollectionLocalisations.of(context).deletedString(GameCollectionLocalisations.of(context).finishDateFieldString);
                showSnackBar(
                  context,
                  message: message,
                );
              }
              if(state is RelationNotDeleted) {
                final String message = GameCollectionLocalisations.of(context).unableToDeleteString(GameCollectionLocalisations.of(context).finishDateFieldString);
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
        child: BlocBuilder<SingleCalendarBloc, SingleCalendarState>(
          builder: (BuildContext context, SingleCalendarState state) {

            if(state is CalendarLoaded) {

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildTableCalendar(context, state.logDates, state.finishDates, state.selectedDate),
                  const Divider(height: 4.0),
                  state.isSelectedDateFinish? _buildFinishDate(context, state.selectedDate) : Container(),
                  state.isSelectedDateFinish? const Divider(height: 4.0) : Container(),
                  ListTile(
                    title: Text(GameCollectionLocalisations.of(context).timeLogsFieldString + ' - ' + GameCollectionLocalisations.of(context).dateString(state.selectedDate) + ((state.style == CalendarStyle.Graph)? ' (' + GameCollectionLocalisations.of(context).weekString + ')' : '')),
                    trailing: Text(GameCollectionLocalisations.of(context).durationString(state.selectedTotalTime)),
                  ),
                  Expanded(child: (state.style == CalendarStyle.List)? _buildEventList(context, state.selectedTimeLogs) : _buildEventGraph(context, state.selectedTimeLogs)),
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
        ),
      ),
    );

  }

  Widget _buildTableCalendar(BuildContext context, Set<DateTime> logDates, List<DateTime> finishDates, DateTime selectedDate) {
    DateTime firstDate = DateTime.now();
    DateTime lastDate = firstDate;
    if(logDates.isNotEmpty) {
      firstDate = logDates.first;
      lastDate = logDates.last;
    }

    return table_calendar.TableCalendar<DateTime>(
      firstDay: firstDate,
      lastDay: lastDate,
      focusedDay: selectedDate,
      selectedDayPredicate: (DateTime day) {
        return day.isSameDate(selectedDate);
      },
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        BlocProvider.of<SingleCalendarBloc>(context).add(
          UpdateSelectedDate(
            selectedDay,
          ),
        );
      },
      eventLoader: (DateTime date) {
        return logDates.where((DateTime logDate) => date.isSameDate(logDate)).toList(growable: false);
      },
      holidayPredicate: (DateTime date) {
        return finishDates.any((DateTime finishDate) => date.isSameDate(finishDate));
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

  Widget _buildFinishDate(BuildContext context, DateTime selectedDate) {

    return ListTile(
      title: Text(GameCollectionLocalisations.of(context).selectedDateIsFinishDateString),
      trailing: IconButton(
        icon: const Icon(Icons.link_off),
        onPressed: () {
          BlocProvider.of<GameFinishDateRelationManagerBloc>(context).add(
            DeleteRelation<DateTime>(
              selectedDate,
            ),
          );
        },
      ),
      tileColor: GameTheme.playedStatusColour,
    );

  }

  Widget _buildEventList(BuildContext context, List<TimeLog> timeLogs) {

    if(timeLogs.isEmpty) {
      return Center(
        child: Text(GameCollectionLocalisations.of(context).emptyTimeLogsString),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: timeLogs.length,
      itemBuilder: (BuildContext context, int index) {
        final TimeLog timeLog = timeLogs.elementAt(index);
        final String timeLogString = GameCollectionLocalisations.of(context).timeString(timeLog.dateTime) + ' - ' + GameCollectionLocalisations.of(context).durationString(timeLog.time);

        return DismissibleItem(
          dismissibleKey: timeLog.dateTime.millisecond,
          itemWidget: ListTile(
            title: Text(timeLogString),
            trailing: IconButton(
              icon: const Icon(Icons.link_off),
              onPressed: () {
                BlocProvider.of<GameTimeLogRelationManagerBloc>(context).add(
                  DeleteRelation<TimeLog>(
                    timeLog,
                  ),
                );
              },
            ),
          ),
          onDismissed: (DismissDirection direction) {
            BlocProvider.of<GameTimeLogRelationManagerBloc>(context).add(
              DeleteRelation<TimeLog>(
                timeLog,
              ),
            );
          },
          dismissIcon: Icons.link_off,
        );
      },
    );

  }

  Widget _buildEventGraph(BuildContext context, List<TimeLog> timeLogs) {
    final List<int> values = <int>[];

    final List<DateTime> distinctLogDates = <DateTime>[];
    timeLogs.forEach((TimeLog log) {
      if(!distinctLogDates.any((DateTime date) => date.isSameDate(log.dateTime))) {
        distinctLogDates.add(log.dateTime);
      }
    });
    distinctLogDates.sort();

    distinctLogDates.forEach((DateTime date) {
      final List<Duration> dateDurations = timeLogs.where((TimeLog log) => log.dateTime.isSameDate(date)).map((TimeLog log) => log.time).toList(growable: false);
      final int daySum = dateDurations.fold<int>(0, (int previousValue, Duration duration) => previousValue + duration.inMinutes);
      values.add(daySum);
    });

    return Container(
      child: StatisticsHistogram<int>(
        histogramName: GameCollectionLocalisations.of(context).timeLogsFieldString,
        domainLabels: GameCollectionLocalisations.of(context).shortDaysOfWeek,
        values: values,
        vertical: true,
        hideDomainLabels: false,
        valueFormatter: (int value) => GameCollectionLocalisations.of(context).durationString(Duration(minutes: value)),
      ),
    );
  }

}