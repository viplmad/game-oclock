import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GameTagCreateBloc,
        GameTagFormBloc,
        TagCreateBloc,
        TagListBloc,
        UserGameCreateBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show GameTag, GameTagFormData;
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/shared/selectors/tag_selector.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class GameTagCreateForm extends StatelessWidget {
  const GameTagCreateForm({super.key, this.gameId, this.tagId});

  final String? gameId;
  final String? tagId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameTagFormBloc(
            formGroup: GameTagFormData(
              gameId: TextEditingController(text: gameId),
              tagId: TextEditingController(text: tagId),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              GameTagCreateBloc(service: RepositoryProvider.of(context)),
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
            GameTag,
            GameTagFormData,
            GameTagFormBloc,
            GameTagCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: (final context, final formGroup, final readOnly) =>
                _fieldsCreateBuilder(
                  context,
                  gameId,
                  tagId,
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
  final String? tagId,
  final GameTagFormData formGroup,
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
      TagSelectorBuilder(
        controller: formGroup.tagId,
        label: context.localize().tagLabel,
        required: true,
        readOnly: readOnly || tagId != null,
      ),
    ],
  );
}
