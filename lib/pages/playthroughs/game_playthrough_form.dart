import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        GamePlaythroughCreateBloc,
        GamePlaythroughFormBloc,
        GamePlaythroughGetBloc,
        GamePlaythroughUpdateBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show GamePlaythrough, GamePlaythroughFormData;
import 'package:game_oclock/utils/localisation_extension.dart';

class GamePlaythroughCreateForm extends StatelessWidget {
  const GamePlaythroughCreateForm({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GamePlaythroughFormBloc(
            formGroup: GamePlaythroughFormData(
              gameId: TextEditingController(),
              name: TextEditingController(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => GamePlaythroughCreateBloc(
            service: RepositoryProvider.of(context),
          ),
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
            fieldsBuilder: _fieldsBuilder,
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
            formGroup: GamePlaythroughFormData(
              gameId: TextEditingController(),
              name: TextEditingController(),
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
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final GamePlaythroughFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        controller: formGroup.name,
        label: context.localize().nameLabel,
        required: true,
        readOnly: readOnly,
      ),
    ],
  );
}
