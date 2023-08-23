import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart' show NewGameLogDTO;

import 'package:logic/model/model.dart' show GameLogRecalculationMode;
import 'package:logic/bloc/time_log_assistant/time_log_assistant.dart';
import 'package:logic/utils/time_of_day_extension.dart';

import 'package:game_collection/ui/utils/fab_utils.dart';
import 'package:game_collection/ui/common/field/field.dart'
    show DateField, DurationField, TimeField;

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
          title: Text(AppLocalizations.of(context)!.gameLogFieldString),
          // Fixed elevation so background color doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
        ),
        body: const _GameLogAssistantBody(),
        floatingActionButton:
            BlocBuilder<GameLogAssistantBloc, GameLogAssistantState>(
          builder: (BuildContext context, GameLogAssistantState state) {
            return FloatingActionButton.extended(
              label: Text(AppLocalizations.of(context)!.saveString),
              icon: const Icon(Icons.cloud_upload),
              tooltip: AppLocalizations.of(context)!.saveString,
              onPressed: state.isValid
                  ? () async {
                      final DateTime date = state.date;
                      final TimeOfDay startTime = state.startTime!;

                      final DateTime startDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        startTime.hour,
                        startTime.minute,
                      );

                      final DateTime endDateTime =
                          startDateTime.add(state.duration!);

                      Navigator.maybePop(
                        context,
                        NewGameLogDTO(
                          startDatetime: startDateTime,
                          endDatetime: endDateTime,
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
              fieldName: AppLocalizations.of(context)!.dateString,
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
              fieldName: AppLocalizations.of(context)!.startTimeString,
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
              fieldName: AppLocalizations.of(context)!.endTimeString,
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
              fieldName: AppLocalizations.of(context)!.durationString,
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
          AppLocalizations.of(context)!.recalculationModeTitle,
        ),
        subtitle: Text(
          AppLocalizations.of(context)!.recalculationModeSubtitle,
        ),
      ),
      RadioListTile<GameLogRecalculationMode>(
        title: Text(
          AppLocalizations.of(context)!.recalculationModeDurationString,
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
          AppLocalizations.of(context)!.recalculationModeTimeString,
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
