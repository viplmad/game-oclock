import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show GameTimeLog;
import 'package:backend/bloc/time_log_assistant/time_log_assistant.dart';
import 'package:backend/utils/time_of_day_extension.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/fab_utils.dart';
import '../common/field/field.dart' show DateField, DurationField, TimeField;

class TimeLogAssistant extends StatelessWidget {
  const TimeLogAssistant({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimeLogAssistantBloc>(
      create: (BuildContext context) {
        return TimeLogAssistantBloc();
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(GameCollectionLocalisations.of(context).timeLogFieldString),
          // Fixed elevation so background color doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
        ),
        body: const _TimeLogAssistantBody(),
        floatingActionButton:
            BlocBuilder<TimeLogAssistantBloc, TimeLogAssistantState>(
          builder: (BuildContext context, TimeLogAssistantState state) {
            return FloatingActionButton.extended(
              label: Text(GameCollectionLocalisations.of(context).saveString),
              icon: const Icon(Icons.cloud_upload),
              tooltip: GameCollectionLocalisations.of(context).saveString,
              onPressed: state.isValid
                  ? () {
                      final DateTime date = state.date;
                      final TimeOfDay startTime = state.startTime!;

                      final DateTime dateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        startTime.hour,
                        startTime.minute,
                      );

                      Navigator.maybePop(
                        context,
                        GameTimeLog(
                          dateTime: dateTime,
                          time: state.duration!,
                        ),
                      );
                    }
                  : null,
              foregroundColor: Colors.white,
              backgroundColor:
                  FABUtils.backgroundIfActive(enabled: state.isValid),
            );
          },
        ),
      ),
    );
  }
}

class _TimeLogAssistantBody extends StatelessWidget {
  const _TimeLogAssistantBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeLogAssistantBloc, TimeLogAssistantState>(
      builder: (BuildContext context, TimeLogAssistantState state) {
        return Column(
          children: <Widget>[
            DateField(
              fieldName: GameCollectionLocalisations.of(context).dateString,
              value: state.date,
              update: (DateTime date) {
                BlocProvider.of<TimeLogAssistantBloc>(context).add(
                  UpdateTimeLogDate(
                    date,
                  ),
                );
              },
            ),
            TimeField(
              fieldName:
                  GameCollectionLocalisations.of(context).startTimeString,
              value: state.startTime,
              update: (TimeOfDay time) {
                BlocProvider.of<TimeLogAssistantBloc>(context).add(
                  UpdateTimeLogStartTime(
                    time,
                  ),
                );
              },
              onLongPress: () {
                BlocProvider.of<TimeLogAssistantBloc>(context).add(
                  const UpdateTimeLogStartTime(
                    TimeOfDayExtension.startOfDay,
                  ),
                );
              },
            ),
            TimeField(
              fieldName: GameCollectionLocalisations.of(context).endTimeString,
              value: state.endTime,
              update: (TimeOfDay time) {
                BlocProvider.of<TimeLogAssistantBloc>(context).add(
                  UpdateTimeLogEndTime(
                    time,
                  ),
                );
              },
              onLongPress: () {
                BlocProvider.of<TimeLogAssistantBloc>(context).add(
                  const UpdateTimeLogEndTime(
                    TimeOfDayExtension.startOfDay,
                  ),
                );
              },
            ),
            DurationField(
              fieldName: GameCollectionLocalisations.of(context).durationString,
              value: state.duration,
              update: (Duration duration) {
                BlocProvider.of<TimeLogAssistantBloc>(context).add(
                  UpdateTimeLogDuration(
                    duration,
                  ),
                );
              },
            ),
            ...(state.canRecalculate
                ? _recalculateOptions(context, state.recalculationMode)
                : <Widget>[]),
          ],
        );
      },
    );
  }

  List<Widget> _recalculateOptions(
    BuildContext context,
    TimeLogRecalculationMode recalculationMode,
  ) {
    return <Widget>[
      const Divider(),
      ListTile(
        title: Text(
          GameCollectionLocalisations.of(context).recalculationModeTitle,
        ),
        subtitle: Text(
          GameCollectionLocalisations.of(context).recalculationModeSubtitle,
        ),
      ),
      RadioListTile<TimeLogRecalculationMode>(
        title: Text(
          GameCollectionLocalisations.of(context)
              .recalculationModeDurationString,
        ),
        groupValue: recalculationMode,
        value: TimeLogRecalculationMode.duration,
        onChanged: (_) {
          BlocProvider.of<TimeLogAssistantBloc>(context).add(
            const UpdateTimeLogRecalculationMode(
              TimeLogRecalculationMode.duration,
            ),
          );
        },
      ),
      RadioListTile<TimeLogRecalculationMode>(
        title: Text(
          GameCollectionLocalisations.of(context).recalculationModeTimeString,
        ),
        groupValue: recalculationMode,
        value: TimeLogRecalculationMode.time,
        onChanged: (_) {
          BlocProvider.of<TimeLogAssistantBloc>(context).add(
            const UpdateTimeLogRecalculationMode(
              TimeLogRecalculationMode.time,
            ),
          );
        },
      ),
    ];
  }
}
