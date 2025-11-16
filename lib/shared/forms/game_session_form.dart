import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GameSessionCreateBloc,
        GameSessionFormBloc,
        TagCreateBloc,
        TagListBloc,
        UserGameCreateBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show GameSession, GameSessionFormData, gameSessionFinishedOptions;
import 'package:game_oclock/shared/selectors/device_selector.dart';
import 'package:game_oclock/shared/selectors/game_playthrough_selector.dart';
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

class GameSessionCreateForm extends StatelessWidget {
  const GameSessionCreateForm({super.key, required this.gameId});

  final String gameId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameSessionFormBloc(
            data: GameSessionFormData(
              gameId: FormControl(
                value: gameId,
                validators: [Validators.required],
              ),
              startDateTime: FormControl<DateTime>(
                validators: [Validators.required],
              ),
              endDateTime: FormControl<DateTime>(
                validators: [Validators.required],
              ),
              deviceId: FormControl<String>(validators: [Validators.required]),
              playthroughId: FormControl<String>(),
              started: FormControl<bool>(),
              finished: FormControl<String>(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              GameSessionCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) =>
              UserGameListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) => TagListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => TagCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            GameSession,
            GameSessionFormData,
            GameSessionFormBloc,
            GameSessionCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: (final context, final formGroup, final readOnly) =>
                _fieldsCreateBuilder(context, gameId, formGroup, readOnly),
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final String gameId,
  final GameSessionFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      UserGameSelectorBuilder(
        formControl: formGroup.gameId,
        label: context.localize().gameLabel,
        readOnly: readOnly,
      ),
      SimpleDateTimeFormField(
        formControl: formGroup.startDateTime,
        label: context.localize().startDateTimeLabel,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ),
      SimpleDateTimeFormField(
        formControl: formGroup.endDateTime,
        label: context.localize().endDateTimeLabel,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ), // TODO Range date time form field
      DeviceSelectorBuilder(
        formControl: formGroup.deviceId,
        label: context.localize().deviceLabel,
        readOnly: readOnly,
      ),
      GamePlaythroughSelectorBuilder(
        gameId: gameId,
        formControl: formGroup.playthroughId,
        label: context.localize().playthroughLabel,
        readOnly: readOnly,
      ),
      SimpleBoolFormField(
        formControl: formGroup.started,
        label: context.localize().startedLabel,
        readOnly: readOnly,
      ),
      SimpleChoiceFormField(
        formControl: formGroup.finished,
        label: context.localize().finishedLabel,
        readOnly: readOnly,
        options: gameSessionFinishedOptions,
      ),
    ],
  );
}
