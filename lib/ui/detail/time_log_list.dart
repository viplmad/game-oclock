import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:numberpicker/numberpicker.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';


// ignore: must_be_immutable
abstract class TimeLogList<T extends CollectionItem, K extends RelationBloc<T, TimeLog>, S extends RelationManagerBloc<T, TimeLog>> extends StatelessWidget {
  TimeLogList({
    Key key,
    @required this.fieldName,
    @required this.value,
    @required this.relationTypeName,
    @required this.onUpdate,
  }) : super(key: key);

  final String fieldName;
  final Duration value;
  final String relationTypeName;
  final void Function() onUpdate;

  bool _hasUpdated = false;

  @override
  Widget build(BuildContext outerContext) {

    String shownValue = value != null? GameCollectionLocalisations.of(outerContext).durationString(value) : '';

    return BlocListener<S, RelationManagerState>(
      listener: (BuildContext context, RelationManagerState state) {
        if(state is RelationAdded<TimeLog>) {
          _hasUpdated = true;

          String message = GameCollectionLocalisations.of(context).addedString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
        if(state is RelationNotAdded) {
          String message = GameCollectionLocalisations.of(context).unableToAddString(relationTypeName);
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
        if(state is RelationDeleted<TimeLog>) {
          _hasUpdated = true;

          String message = GameCollectionLocalisations.of(context).deletedString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
        if(state is RelationNotDeleted) {
          String message = GameCollectionLocalisations.of(context).unableToDeleteString(relationTypeName);
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
      child: ListTileTheme.merge(
        child: ListTile(
          title: Text(fieldName),
          trailing: BlocBuilder<K, RelationState>(
            builder: (BuildContext context, RelationState state) {
              String extra = '';
              if(state is RelationLoaded<TimeLog>) {

                extra = state.otherItems.isNotEmpty? '(' + state.otherItems.length.toString() + ')' : '';

              }

              return Text(shownValue + ' ' + extra);
            },
          ),
          onTap: () {

            showDialog(
              context: outerContext,
              builder: (BuildContext context) {

                return WillPopScope(
                  onWillPop: () {

                    if(_hasUpdated) { onUpdate(); }
                    return Future<bool>.value(true);

                  },
                  child: AlertDialog(
                    title: Text(fieldName),
                    content: Container(
                      width: double.maxFinite,
                      child: BlocBuilder<K, RelationState>(
                        cubit: BlocProvider.of<K>(outerContext),
                        builder: (BuildContext context, RelationState state) {

                          if(state is RelationLoaded<TimeLog>) {

                            final List<TimeLog> values = state.otherItems;

                            if(values.isEmpty) {
                              return Text(GameCollectionLocalisations.of(context).emptyTimeLogsString);
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (BuildContext context, int index) {
                                TimeLog timeLog = values.elementAt(index);
                                String timeLogString = GameCollectionLocalisations.of(context).dateTimeString(timeLog.dateTime) + ' - ' + GameCollectionLocalisations.of(context).durationString(timeLog.time);

                                return Padding(
                                  padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
                                  child: ListTile(
                                    title: Text(timeLogString),
                                    trailing: IconButton(
                                      icon: Icon(Icons.link_off),
                                      onPressed: () {
                                        BlocProvider.of<S>(outerContext).add(
                                          DeleteRelation<TimeLog>(timeLog),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          if(state is RelationNotLoaded) {
                            return Center(
                              child: Text(state.error),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              LinearProgressIndicator(),
                            ],
                          );
                        },

                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(GameCollectionLocalisations.of(context).addString(relationTypeName)),
                        onPressed: () {

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

                                      return _DurationPickerDialog(
                                        initialDuration: value,
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

                                      BlocProvider.of<S>(outerContext).add(
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
                      FlatButton(
                        child: Text(MaterialLocalizations.of(context).okButtonLabel),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                    ],
                  ),
                );

              },
            );

          },
        ),
      ),
    );

  }
}

class _DurationPickerDialog extends StatefulWidget {
  const _DurationPickerDialog({
    Key key,
    @required this.initialDuration,
  }) : super(key: key);

  final Duration initialDuration;

  @override
  State<_DurationPickerDialog> createState() => _DurationPickerDialogState();
}
class _DurationPickerDialogState extends State<_DurationPickerDialog> {
  int _hours;
  int _minutes;

  @override
  void initState() {
    super.initState();

    _hours = widget.initialDuration.inHours;
    _minutes = widget.initialDuration.inMinutes - (_hours * 60);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NumberPicker.integer(
              initialValue: _hours,
              minValue: 0,
              maxValue: 1000,
              highlightSelectedValue: true,
              onChanged: (num newHours) {
                setState(() {
                  _hours = newHours;
                });
              }
          ),
          Text(':', style: Theme.of(context).textTheme.headline6,),
          NumberPicker.integer(
              initialValue: _minutes,
              minValue: 0,
              maxValue: 59,
              highlightSelectedValue: true,
              onChanged: (num newMin) {
                setState(() {
                  _minutes = newMin;
                });
              }
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<Duration>(context);
          },
        ),
        FlatButton(
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            Navigator.maybePop<Duration>(context, Duration(hours: _hours, minutes: _minutes));
          },
        ),
      ],
    );
  }
}