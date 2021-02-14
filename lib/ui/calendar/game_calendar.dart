import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart' as tableCalendar;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/calendar/calendar.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart';
import '../common/loading_icon.dart';
import '../common/show_snackbar.dart';
import '../common/statistics_histogram.dart';
import '../common/duration_picker_dialog.dart';


class GameCalendarArguments {
  const GameCalendarArguments({
    @required this.itemId,
    this.onUpdate,
  });

  final int itemId;
  final void Function() onUpdate;
}

class GameCalendar extends StatelessWidget {
  const GameCalendar({
    Key key,
    @required this.itemId,
    this.onUpdate,
  }) : super(key: key);

  final int itemId;
  final void Function() onUpdate;

  @override
  Widget build(BuildContext context) {

    GameTimeLogRelationManagerBloc _timeLogRelationManagerBloc = GameTimeLogRelationManagerBloc(
      itemId: itemId,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    GameFinishDateRelationManagerBloc _finishRelationManagerBloc = GameFinishDateRelationManagerBloc(
      itemId: itemId,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    CalendarBloc _bloc = blocBuilder(_timeLogRelationManagerBloc, _finishRelationManagerBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarBloc>(
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
        floatingActionButton: _buildSpeedDial(context, _timeLogRelationManagerBloc, _finishRelationManagerBloc),
      ),
    );

  }

  CalendarBloc blocBuilder(GameTimeLogRelationManagerBloc timeLogManagerBloc, GameFinishDateRelationManagerBloc finishDateManagerBloc) {

    return CalendarBloc(
      itemId: itemId,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
      timeLogManagerBloc: timeLogManagerBloc,
      finishDateManagerBloc: finishDateManagerBloc,
    );

  }

  SpeedDial _buildSpeedDial(BuildContext context, GameTimeLogRelationManagerBloc timeLogManagerBloc, GameFinishDateRelationManagerBloc finishDateManagerBloc) {

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.remove,
      tooltip: GameCollectionLocalisations.of(context).addString(GameCollectionLocalisations.of(context).gameCalendarEventsString),
      overlayColor: Colors.black,
      backgroundColor: GameTheme.primaryColour,
      curve: Curves.bounceIn,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add_alarm),
          label: GameCollectionLocalisations.of(context).addString(GameCollectionLocalisations.of(context).timeLogFieldString),
          labelStyle: TextStyle(color: Colors.white),
          backgroundColor: GameTheme.primaryColour,
          onTap: () {

            showDatePicker(
              context: context,
              firstDate: DateTime(1970),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
            ).then((DateTime date) {
              if(date != null) {

                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((TimeOfDay time) {
                  if(time != null) {

                    showDialog<Duration>(
                      context: context,
                      builder: (BuildContext context) {

                        return DurationPickerDialog(
                          fieldName: GameCollectionLocalisations.of(context).editTimeString,
                          initialDuration: Duration.zero,
                        );

                      },
                    ).then((Duration duration) {
                      if(duration != null) {

                        DateTime dateTime = DateTime(
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
          child: Icon(Icons.event_available),
          label: GameCollectionLocalisations.of(context).addString(GameCollectionLocalisations.of(context).finishDateFieldString),
          labelStyle: TextStyle(color: Colors.white),
          backgroundColor: GameTheme.primaryColour,
          onTap: () {

            showDatePicker(
              context: context,
              firstDate: DateTime(1970),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
            ).then((DateTime value) {
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

  _GameCalendarBody bodyBuilder() {

    return _GameCalendarBody(
      onUpdate: onUpdate,
    );

  }

}

class _GameCalendarBody extends StatefulWidget {
  const _GameCalendarBody({Key key, @required this.onUpdate}) : super(key: key);

  final void Function() onUpdate;

  @override
  State<_GameCalendarBody> createState() => _GameCalendarBodyState();
}
class _GameCalendarBodyState extends State<_GameCalendarBody> {
  tableCalendar.CalendarController _calendarController;

  bool _isUpdated;

  @override
  void initState() {
    super.initState();

    _calendarController = tableCalendar.CalendarController();
    _isUpdated = false;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {

        if(_isUpdated && widget.onUpdate != null) { widget.onUpdate(); }
        return Future<bool>.value(true);

      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<GameTimeLogRelationManagerBloc, RelationManagerState>(
            listener: (BuildContext context, RelationManagerState state) {
              if(state is RelationAdded<TimeLog>) {
                _isUpdated = true;

                String message = GameCollectionLocalisations.of(context).addedString(GameCollectionLocalisations.of(context).timeLogFieldString);
                showSnackBar(
                  scaffoldState: Scaffold.of(context),
                  message: message,
                );
              }
              if(state is RelationNotAdded) {
                String message = GameCollectionLocalisations.of(context).unableToAddString(GameCollectionLocalisations.of(context).timeLogFieldString);
                showSnackBar(
                  scaffoldState: Scaffold.of(context),
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

                String message = GameCollectionLocalisations.of(context).deletedString(GameCollectionLocalisations.of(context).timeLogFieldString);
                showSnackBar(
                  scaffoldState: Scaffold.of(context),
                  message: message,
                );
              }
              if(state is RelationNotDeleted) {
                String message = GameCollectionLocalisations.of(context).unableToDeleteString(GameCollectionLocalisations.of(context).timeLogFieldString);
                showSnackBar(
                  scaffoldState: Scaffold.of(context),
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

                String message = GameCollectionLocalisations.of(context).addedString(GameCollectionLocalisations.of(context).finishDateFieldString);
                showSnackBar(
                  scaffoldState: Scaffold.of(context),
                  message: message,
                );
              }
              if(state is RelationNotAdded) {
                String message = GameCollectionLocalisations.of(context).unableToAddString(GameCollectionLocalisations.of(context).finishDateFieldString);
                showSnackBar(
                  scaffoldState: Scaffold.of(context),
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

                String message = GameCollectionLocalisations.of(context).deletedString(GameCollectionLocalisations.of(context).finishDateFieldString);
                showSnackBar(
                  scaffoldState: Scaffold.of(context),
                  message: message,
                );
              }
              if(state is RelationNotDeleted) {
                String message = GameCollectionLocalisations.of(context).unableToDeleteString(GameCollectionLocalisations.of(context).finishDateFieldString);
                showSnackBar(
                  scaffoldState: Scaffold.of(context),
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
          BlocListener<CalendarBloc, CalendarState>(
            listener: (BuildContext context, CalendarState state) {
              if(state is CalendarLoaded) {
                try {
                  _calendarController.setSelectedDay(state.selectedDate);
                } catch (NoSuchMethodError) {}
              }
            },
          ),
        ],
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (BuildContext context, CalendarState state) {

            if(state is CalendarLoaded) {

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildTableCalendar(context, state.timeLogs, state.finishDates, state.selectedDate),
                  const Divider(height: 4.0),
                  state.isSelectedDateFinish? _buildFinishDate(context, state.selectedDate) : Container(),
                  state.isSelectedDateFinish? const Divider(height: 4.0) : Container(),
                  ListTile(
                    title: Text(GameCollectionLocalisations.of(context).timeLogsFieldString + " - " + GameCollectionLocalisations.of(context).dateString(state.selectedDate) + ((state.style == CalendarStyle.Graph)? " (" + GameCollectionLocalisations.of(context).weekString + ")" : "")),
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

            return LoadingIcon();

          },
        ),
      ),
    );

  }

  Widget _buildTableCalendar(BuildContext context, List<TimeLog> timeLogs, List<DateTime> finishDates, DateTime selectedDate) {
    Map<DateTime, List<Duration>> eventsMap = _convertTimeLogsToMap(timeLogs);
    Map<DateTime, List<int>> holidaysMap = _convertFinishDatesToMap(finishDates);

    DateTime firstDate = DateTime.now();
    DateTime lastDate = firstDate;
    if(timeLogs.isNotEmpty) {
      firstDate = timeLogs.first.dateTime;
      lastDate = timeLogs.last.dateTime;
    }

    return tableCalendar.TableCalendar(
      calendarController: _calendarController,
      events: eventsMap,
      holidays: holidaysMap,
      startingDayOfWeek: tableCalendar.StartingDayOfWeek.monday,
      startDay: firstDate,
      endDay: lastDate,
      initialSelectedDay: selectedDate,
      calendarStyle: tableCalendar.CalendarStyle(
        selectedColor: GameTheme.primaryColour,
        todayColor: Colors.yellow[800],
        outsideDaysVisible: false,
      ),
      availableGestures: tableCalendar.AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        tableCalendar.CalendarFormat.month: '',
      },
      headerStyle: tableCalendar.HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: tableCalendar.CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final List<Widget> children = List<Widget>();

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: 15,
                top: 15,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (DateTime day, List events, List holidays) {
        BlocProvider.of<CalendarBloc>(context).add(
          UpdateSelectedDate(
            day,
          ),
        );
      },
    );
  }

  Widget _buildFinishDate(BuildContext context, DateTime selectedDate) {

    return ListTile(
      title: Text(GameCollectionLocalisations.of(context).selectedDateIsFinishDateString),
      trailing: IconButton(
        icon: Icon(Icons.link_off),
        onPressed: () {
          BlocProvider.of<GameFinishDateRelationManagerBloc>(context).add(
            DeleteRelation<DateTime>(
              selectedDate,
            ),
          );
        },
      ),
      tileColor: GameTheme.statusColours.last,
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
        TimeLog timeLog = timeLogs.elementAt(index);
        String timeLogString = GameCollectionLocalisations.of(context).timeString(timeLog.dateTime) + ' - ' + GameCollectionLocalisations.of(context).durationString(timeLog.time);

        return Padding(
          padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
          child: ListTile(
            title: Text(timeLogString),
            trailing: IconButton(
              icon: Icon(Icons.link_off),
              onPressed: () {
                BlocProvider.of<GameTimeLogRelationManagerBloc>(context).add(
                  DeleteRelation<TimeLog>(
                    timeLog,
                  ),
                );
              },
            ),
          ),
        );
      },
    );

  }

  Widget _buildEventGraph(BuildContext context, List<TimeLog> timeLogs) {
    List<int> values = List<int>();

    List<DateTime> distinctLogDates = List<DateTime>();
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
  }

  Map<DateTime, List> _convertTimeLogsToMap(List<TimeLog> timeLogs) {
    Map<DateTime, List<Duration>> map = Map<DateTime, List<Duration>>();

    List<DateTime> distinctLogDates = List<DateTime>();
    timeLogs.forEach((TimeLog log) {
      if(!distinctLogDates.any((DateTime date) => date.isSameDate(log.dateTime))) {
        distinctLogDates.add(log.dateTime);
      }
    });
    distinctLogDates.sort();

    distinctLogDates.forEach((DateTime date) {
      List<Duration> dateDurations = timeLogs.where((TimeLog log) => log.dateTime.isSameDate(date)).map((TimeLog log) => log.time).toList(growable: false);
      map[date] = dateDurations;
    });

    return map;
  }

  Map<DateTime, List> _convertFinishDatesToMap(List<DateTime> finishDates) {
    Map<DateTime, List<int>> map = Map<DateTime, List<int>>();

    finishDates.forEach((DateTime date) {
      List<int> notEmptyList = List<int>();
      notEmptyList.add(0);
      map[date] = notEmptyList;
    });

    return map;
  }

  Widget _buildEventsMarker() {

    return Icon(
      Icons.circle,
      size: 20.0,
      color: GameTheme.statusColours.elementAt(GameTheme.statusColours.length - 2),
    );

  }

  Widget _buildHolidaysMarker() {

    return Icon(
      Icons.add_box,
      size: 20.0,
      color: GameTheme.statusColours.last,
    );

  }

}