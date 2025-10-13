import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GameSessionCreateBloc,
        GameSessionFormBloc,
        ListLoaded,
        TagCreateBloc,
        TagListBloc,
        UserGameCreateBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show
        GameSession,
        GameSessionFormData,
        ListSearch,
        SearchDTO,
        gameSessionFinishedOptions;
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/shared/selectors/tag_selector.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class GameSessionCreateForm extends StatelessWidget {
  const GameSessionCreateForm({super.key, this.gameId});

  final String? gameId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameSessionFormBloc(
            formGroup: GameSessionFormData(
              gameId: TextEditingController(text: gameId),
              startDateTime: DateTimeEditingController(),
              endDateTime: DateTimeEditingController(),
              deviceId: TextEditingController(),
              playthroughId: TextEditingController(),
              started: BoolEditingController(),
              finished: TextEditingController(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              GameSessionCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) =>
              UserGameListBloc(service: RepositoryProvider.of(context))..add(
                // Requires search to be loaded
                ListLoaded(
                  search: ListSearch(name: 'default', search: SearchDTO()),
                ),
              ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) =>
              TagListBloc(service: RepositoryProvider.of(context))..add(
                // Requires search to be loaded
                ListLoaded(
                  search: ListSearch(name: 'default', search: SearchDTO()),
                ),
              ),
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
  final String? gameId,
  final GameSessionFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      UserGameSelectorBuilder(
        controller: formGroup.gameId,
        label: context.localize().gameLabel,
        required: true,
        readOnly: readOnly || gameId != null,
      ),
      SimpleDateTimeFormField(
        controller: formGroup.startDateTime,
        label: context.localize().startDateTimeLabel,
        required: true,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ),
      SimpleDateTimeFormField(
        controller: formGroup.endDateTime,
        label: context.localize().endDateTimeLabel,
        required: true,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ), // TODO Range date time form field
      /*DeviceSelectorBuilder(
        controller: formGroup.deviceId,
        label: context.localize().deviceLabel,
        required: true,
        readOnly: readOnly,
      ),
      GamePlaythroughSelectorBuilder(
        controller: formGroup.playthroughId,
        label: context.localize().playthroughLabel,
        readOnly: readOnly,
      ),*/
      SimpleBoolFormField(
        controller: formGroup.started,
        label: context.localize().startedLabel,
        readOnly: readOnly,
      ),
      SimpleChoiceFormField(
        controller: formGroup.finished,
        label: context.localize().finishedLabel,
        readOnly: readOnly,
        options: gameSessionFinishedOptions,
      ),
    ],
  );
}
