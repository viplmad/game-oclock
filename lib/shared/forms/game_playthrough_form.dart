import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        GamePlaythroughCreateBloc,
        GamePlaythroughFormBloc,
        GamePlaythroughGetBloc,
        GamePlaythroughUpdateBloc,
        UserGameCreateBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show GamePlaythrough, GamePlaythroughFormData;
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

class GamePlaythroughCreateForm extends StatelessWidget {
  const GamePlaythroughCreateForm({super.key, this.initialName, this.gameId});

  final String? initialName;
  final String? gameId;

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
              name: FormControl<String>(
                value: initialName,
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
              UserGameListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            GamePlaythrough,
            GamePlaythroughFormData,
            GamePlaythroughFormBloc,
            GamePlaythroughCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: (final context, final formGroup, final readOnly) =>
                _fieldsCreateBuilder(context, gameId, formGroup, readOnly),
          ),
    );
  }
}

class GamePlaythroughEditForm extends StatelessWidget {
  const GamePlaythroughEditForm({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GamePlaythroughFormBloc(
            data: GamePlaythroughFormData(
              gameId: FormControl<String>(disabled: true),
              name: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => GamePlaythroughUpdateBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) =>
              GamePlaythroughGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            GamePlaythrough,
            GamePlaythroughFormData,
            GamePlaythroughFormBloc,
            GamePlaythroughGetBloc,
            GamePlaythroughUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsEditBuilder,
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final String? gameId,
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
      SimpleTextFormField(
        formControl: formGroup.name,
        label: context.localize().nameLabel,
        readOnly: readOnly,
      ),
    ],
  );
}

Widget _fieldsEditBuilder(
  final BuildContext context,
  final GamePlaythroughFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        formControl: formGroup.name,
        label: context.localize().nameLabel,
        readOnly: readOnly,
      ),
    ],
  );
}
