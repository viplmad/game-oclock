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
import 'package:reactive_forms/reactive_forms.dart';

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
            data: GameTagFormData(
              gameId: FormControl<String>(
                value: gameId,
                validators: [Validators.required],
                disabled: gameId != null,
              ),
              tagId: FormControl<String>(
                value: tagId,
                validators: [Validators.required],
                disabled: tagId != null,
              ),
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
            fieldsBuilder: _fieldsCreateBuilder,
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final GameTagFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      UserGameSelectorBuilder(
        formControl: formGroup.gameId,
        label: context.localize().gameLabel,
        readOnly: readOnly,
      ),
      TagSelectorBuilder(
        formControl: formGroup.tagId,
        label: context.localize().tagLabel,
        readOnly: readOnly,
      ),
    ],
  );
}
