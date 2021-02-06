import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/calendar/calendar.dart';
import 'package:game_collection/bloc/calendar_manager/calendar_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../common/duration_picker_dialog.dart';


class GameCalendarView extends StatelessWidget {
  const GameCalendarView({
    Key key,
    @required this.itemId,
  }) : super(key: key);

  final int itemId;

  @override
  Widget build(BuildContext context) {

    CalendarManagerBloc _managerBloc = managerBlocBuilder();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarBloc>(
          create: (BuildContext context) {
            return blocBuilder(_managerBloc)..add(LoadCalendar());
          },
        ),

        BlocProvider<CalendarManagerBloc>(
          create: (BuildContext context) {
            return _managerBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Time Logs & Finish Dates"),
        ),
        body: bodyBuilder(),
        floatingActionButton: buildSpeedDial(context, _managerBloc),
      ),
    );

  }

  CalendarBloc blocBuilder(CalendarManagerBloc managerBloc) {

    return CalendarBloc(
      itemId: itemId,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
      managerBloc: managerBloc,
    );

  }

  CalendarManagerBloc managerBlocBuilder() {

    return CalendarManagerBloc(
      itemId: itemId,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  _GameCalendarBody bodyBuilder() {

    return _GameCalendarBody();

  }

  SpeedDial buildSpeedDial(BuildContext context, CalendarManagerBloc managerBloc) {

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.accessibility, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          label: 'Add Time Log',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
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
                          fieldName: GameCollectionLocalisations.of(context).timeString,
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

                        managerBloc.add(
                          AddTimeLog(
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
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          label: 'Add Finish Date',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
          onTap: () {

            showDatePicker(
              context: context,
              firstDate: DateTime(1970),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
            ).then((DateTime value) {
              if(value != null) {
                managerBloc.add(
                  AddFinishDate(value),
                );
              }
            });

          },
        ),
      ],
    );

  }

}

class _GameCalendarBody extends StatefulWidget {
  const _GameCalendarBody({Key key}) : super(key: key);

  @override
  State<_GameCalendarBody> createState() => _GameCalendarBodyState();
}
class _GameCalendarBodyState extends State<_GameCalendarBody> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<CalendarManagerBloc, CalendarManagerState>(
      listener: (BuildContext context, CalendarManagerState state) {
        if(state is TimeLogAdded) {
          String message = GameCollectionLocalisations.of(context).addedString(GameCollectionLocalisations.of(context).timeLogFieldString);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
        if(state is TimeLogNotAdded) {
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
        if(state is TimeLogDeleted) {
          String message = GameCollectionLocalisations.of(context).deletedString(GameCollectionLocalisations.of(context).timeLogFieldString);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
        if(state is TimeLogNotDeleted) {
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

        if(state is FinishDateAdded) {
          String message = GameCollectionLocalisations.of(context).addedString(GameCollectionLocalisations.of(context).finishDateFieldString);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
        if(state is FinishDateNotAdded) {
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
        if(state is FinishDateDeleted) {
          String message = GameCollectionLocalisations.of(context).deletedString(GameCollectionLocalisations.of(context).finishDateFieldString);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
        if(state is FinishDateNotDeleted) {
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
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (BuildContext context, CalendarState state) {

          if(state is CalendarLoaded) {

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTableCalendar(context, state.timeLogs, state.finishDates, state.selectedDate),
                const SizedBox(height: 8.0),
                Expanded(child: _buildEventList(context, state.selectedTimeLogs)),
              ],
            );

          }
          if(state is CalendarNotLoaded) {

            return Center(
              child: Text(state.error),
            );

          }

          return Container();

        },
      ),
    );

  }

  Widget _buildTableCalendar(BuildContext context, List<TimeLog> timeLogs, List<DateTime> finishDates, DateTime selectedDate) {
    Map<DateTime, List<Duration>> eventsMap = _convertTimeLogsToMap(timeLogs);
    Map<DateTime, List<int>> holidaysMap = _convertFinishDatesToMap(finishDates);

    return TableCalendar(
      calendarController: _calendarController,
      events: eventsMap,
      holidays: holidaysMap,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final List<Widget> children = List<Widget>();

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
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

  Widget _buildEventList(BuildContext context, List<TimeLog> timeLogs) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: timeLogs.length,
      itemBuilder: (BuildContext context, int index) {
        TimeLog timeLog = timeLogs.elementAt(index);
        String timeLogString = GameCollectionLocalisations.of(context).dateTimeString(timeLog.dateTime) + ' - ' + GameCollectionLocalisations.of(context).durationString(timeLog.time);

        return Padding(
          padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
          child: ListTile(
            title: Text(timeLogString),
            trailing: IconButton(
              icon: Icon(Icons.link_off),
              onPressed: () {
                BlocProvider.of<CalendarManagerBloc>(context).add(
                  DeleteTimeLog(
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

  Map<DateTime, List> _convertTimeLogsToMap(List<TimeLog> timeLogs) {
    Map<DateTime, List<Duration>> map = Map<DateTime, List<Duration>>();

    HashSet<DateTime> distinctLogDates = HashSet.from(timeLogs.map((TimeLog log) => log.dateTime));
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

  Widget _buildEventsMarker(DateTime date, List events) {

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
            ? Colors.brown[300]
            : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );

  }

  Widget _buildHolidaysMarker() {

    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );

  }

}