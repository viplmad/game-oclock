import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart' show GameLogDTO;

import 'package:backend/bloc/time_log_assistant/time_log_assistant.dart';
import 'package:backend/utils/time_of_day_extension.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../utils/fab_utils.dart';
import '../common/field/field.dart' show DateField, DurationField, TimeField;

class GameLogAssistant extends StatelessWidget {
  const GameLogAssistant({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameLogAssistantBloc>(
      create: (BuildContext context) {
        return GameLogAssistantBloc();
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(GameCollectionLocalisations.of(context).gameLogFieldString),
          // Fixed elevation so background color doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
        ),
        body: const _GameLogAssistantBody(),
        floatingActionButton:
            BlocBuilder<GameLogAssistantBloc, GameLogAssistantState>(
          builder: (BuildContext context, GameLogAssistantState state) {
            return FloatingActionButton.extended(
              label: Text(GameCollectionLocalisations.of(context).saveString),
              icon: const Icon(Icons.cloud_upload),
              tooltip: GameCollectionLocalisations.of(context).saveString,
              onPressed: state.isValid
                  ? () async {
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
                        GameLogDTO(
                          datetime: dateTime,
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

class _GameLogAssistantBody extends StatelessWidget {
  const _GameLogAssistantBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameLogAssistantBloc, GameLogAssistantState>(
      builder: (BuildContext context, GameLogAssistantState state) {
        return Column(
          children: <Widget>[
            DateField(
              fieldName: GameCollectionLocalisations.of(context).dateString,
              value: state.date,
              update: (DateTime date) {
                BlocProvider.of<GameLogAssistantBloc>(context).add(
                  UpdateGameLogDate(
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
                BlocProvider.of<GameLogAssistantBloc>(context).add(
                  UpdateGameLogStartTime(
                    time,
                  ),
                );
              },
              onLongPress: () {
                BlocProvider.of<GameLogAssistantBloc>(context).add(
                  const UpdateGameLogStartTime(
                    TimeOfDayExtension.startOfDay,
                  ),
                );
              },
            ),
            TimeField(
              fieldName: GameCollectionLocalisations.of(context).endTimeString,
              value: state.endTime,
              update: (TimeOfDay time) {
                BlocProvider.of<GameLogAssistantBloc>(context).add(
                  UpdateGameLogEndTime(
                    time,
                  ),
                );
              },
              onLongPress: () {
                BlocProvider.of<GameLogAssistantBloc>(context).add(
                  const UpdateGameLogEndTime(
                    TimeOfDayExtension.startOfDay,
                  ),
                );
              },
            ),
            DurationField(
              fieldName: GameCollectionLocalisations.of(context).durationString,
              value: state.duration,
              update: (Duration duration) {
                BlocProvider.of<GameLogAssistantBloc>(context).add(
                  UpdateGameLogDuration(
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
    GameLogRecalculationMode recalculationMode,
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
      RadioListTile<GameLogRecalculationMode>(
        title: Text(
          GameCollectionLocalisations.of(context)
              .recalculationModeDurationString,
        ),
        groupValue: recalculationMode,
        value: GameLogRecalculationMode.duration,
        onChanged: (_) {
          BlocProvider.of<GameLogAssistantBloc>(context).add(
            const UpdateGameLogRecalculationMode(
              GameLogRecalculationMode.duration,
            ),
          );
        },
      ),
      RadioListTile<GameLogRecalculationMode>(
        title: Text(
          GameCollectionLocalisations.of(context).recalculationModeTimeString,
        ),
        groupValue: recalculationMode,
        value: GameLogRecalculationMode.time,
        onChanged: (_) {
          BlocProvider.of<GameLogAssistantBloc>(context).add(
            const UpdateGameLogRecalculationMode(
              GameLogRecalculationMode.time,
            ),
          );
        },
      ),
    ];
  }
}
