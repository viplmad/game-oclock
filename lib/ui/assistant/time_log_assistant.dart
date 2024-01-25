import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart' show NewGameLogDTO;

import 'package:logic/model/model.dart'
    show GameLogErrorCode, GameLogRecalculationMode;
import 'package:logic/bloc/time_log_assistant/time_log_assistant.dart';
import 'package:logic/bloc/time_log_assistant_manager/time_log_assistant_manager.dart';
import 'package:logic/utils/datetime_extension.dart';
import 'package:logic/utils/time_of_day_extension.dart';

import 'package:game_oclock/ui/utils/fab_utils.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/field/field.dart'
    show DateField, DurationField, TimeField;
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/theme/theme.dart' show AppTheme;

class GameLogAssistant extends StatelessWidget {
  const GameLogAssistant({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameLogAssistantManagerBloc managerBloc =
        GameLogAssistantManagerBloc();

    final GameLogAssistantBloc bloc = GameLogAssistantBloc(
      managerBloc: managerBloc,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<GameLogAssistantBloc>(
          create: (BuildContext context) {
            return bloc;
          },
        ),
        BlocProvider<GameLogAssistantManagerBloc>(
          create: (BuildContext context) {
            return managerBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.gameLogFieldString),
          // Fixed elevation so background colour doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
        ),
        body: const _GameLogAssistantBody(),
        floatingActionButton:
            BlocBuilder<GameLogAssistantBloc, GameLogAssistantState>(
          builder: (BuildContext context, GameLogAssistantState state) {
            return FloatingActionButton.extended(
              label: Text(AppLocalizations.of(context)!.saveString),
              icon: const Icon(AppTheme.acceptIcon),
              tooltip: AppLocalizations.of(context)!.saveString,
              onPressed: state.isComplete
                  ? () async {
                      final DateTime startDateTime =
                          state.startDate.withTime(state.startTime!);
                      final DateTime endDateTime =
                          state.endDate.withTime(state.endTime!);

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
                  FABUtils.backgroundIfActive(enabled: state.isComplete),
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
    return BlocListener<GameLogAssistantManagerBloc,
        GameLogAssistantManagerState>(
      listener: (BuildContext context, GameLogAssistantManagerState state) {
        if (state is GameLogAssistantInvalid) {
          final String name = AppLocalizations.of(context)!.invalidSession;
          final String message = _getErrorMessage(context, state.error);
          final String title = '$name - $message';
          showSnackBar(
            context,
            message: title,
          );
        }
      },
      child: BlocBuilder<GameLogAssistantBloc, GameLogAssistantState>(
        builder: (BuildContext context, GameLogAssistantState state) {
          return Column(
            children: <Widget>[
              DateField(
                fieldName: AppLocalizations.of(context)!.startDateString,
                value: state.startDate,
                lastDate: state.endDate,
                update: (DateTime date) {
                  BlocProvider.of<GameLogAssistantBloc>(context).add(
                    UpdateGameLogStartDate(
                      date,
                    ),
                  );
                },
                onLongPress: () {
                  BlocProvider.of<GameLogAssistantBloc>(context).add(
                    UpdateGameLogStartDate(
                      state.endDate,
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
              DateField(
                fieldName: AppLocalizations.of(context)!.endDateString,
                value: state.endDate,
                firstDate: state.startDate,
                update: (DateTime date) {
                  BlocProvider.of<GameLogAssistantBloc>(context).add(
                    UpdateGameLogEndDate(
                      date,
                    ),
                  );
                },
                onLongPress: () {
                  BlocProvider.of<GameLogAssistantBloc>(context).add(
                    UpdateGameLogEndDate(
                      state.startDate,
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
              const ListDivider(),
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
              ...(state.isComplete
                  ? _recalculateOptions(context, state.recalculationMode)
                  : <Widget>[]),
            ],
          );
        },
      ),
    );
  }

  String _getErrorMessage(BuildContext context, GameLogErrorCode error) {
    switch (error) {
      case GameLogErrorCode.startDateAfterEndDate:
        return AppLocalizations.of(context)!
            .startDateMustBePreviousEndDateString;
      case GameLogErrorCode.startDateTimeAfterEndDateTime:
        return AppLocalizations.of(context)!
            .startDateTimeMustBePreviousEndDateTimeString;
      case GameLogErrorCode.durationEmptyOrNegative:
        return AppLocalizations.of(context)!.durationMustNotBeEmptyString;
    }
  }

  List<Widget> _recalculateOptions(
    BuildContext context,
    GameLogRecalculationMode recalculationMode,
  ) {
    return <Widget>[
      const ListDivider(),
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
