import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GameSessionCreateBloc,
        GameSessionFormBloc,
        PlaythroughCreateBloc,
        PlaythroughGetBloc,
        PlaythroughListBloc,
        UserGameCreateBloc,
        UserGameGetBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show GameSessionFormData, NewMediaSession, gameSessionFinishedOptions;
import 'package:game_oclock/shared/selectors/device_selector.dart';
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/shared/selectors/playthrough_selector.dart';
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';
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
                validators: [NotEmptyValidator(context)],
              ),
              startDateTime: FormControl<DateTime>(
                validators: [NotEmptyValidator(context)],
              ),
              endDateTime: FormControl<DateTime>(
                validators: [NotEmptyValidator(context)],
              ),
              deviceId: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
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
              UserGameGetBloc(service: RepositoryProvider.of(context)),
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
          create: (_) =>
              PlaythroughGetBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              PlaythroughListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              PlaythroughCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            NewMediaSession,
            SessionDTO,
            (String, DateTime),
            GameSessionFormData,
            GameSessionFormBloc,
            GameSessionCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: _fieldsCreateBuilder,
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
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
      PlaythroughSelectorBuilder(
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
