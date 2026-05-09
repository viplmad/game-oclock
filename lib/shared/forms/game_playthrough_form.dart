import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GamePlaythroughCreateBloc,
        GamePlaythroughFormBloc,
        PlaythroughCreateBloc,
        PlaythroughGetBloc,
        PlaythroughListBloc,
        UserGameCreateBloc,
        UserGameGetBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show GamePlaythrough, GamePlaythroughFormData;
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/shared/selectors/playthrough_selector.dart';
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

class GamePlaythroughCreateForm extends StatelessWidget {
  const GamePlaythroughCreateForm({super.key, this.gameId, this.playthroughId});

  final String? gameId;
  final String? playthroughId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GamePlaythroughFormBloc(
            data: GamePlaythroughFormData(
              gameId: FormControl<String>(
                value: gameId,
                validators: [NotEmptyValidator(context)],
              ),
              playthroughId: FormControl<String>(
                value: playthroughId,
                validators: [NotEmptyValidator(context)],
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => GamePlaythroughCreateBloc(
            service: RepositoryProvider.of(context),
          ),
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
            GamePlaythrough,
            GamePlaythrough,
            (String, String),
            GamePlaythroughFormData,
            GamePlaythroughFormBloc,
            GamePlaythroughCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: (final context, final formGroup, final readOnly) =>
                _fieldsCreateBuilder(
                  context,
                  gameId,
                  playthroughId,
                  formGroup,
                  readOnly,
                ),
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final String? gameId,
  final String? playthroughId,
  final GamePlaythroughFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      UserGameSelectorBuilder(
        formControl: formGroup.gameId,
        label: context.localize().gameLabel,
        readOnly: readOnly || gameId != null,
      ),
      PlaythroughSelectorBuilder(
        formControl: formGroup.playthroughId,
        label: context.localize().playthroughLabel,
        readOnly: readOnly || playthroughId != null,
      ),
    ],
  );
}
