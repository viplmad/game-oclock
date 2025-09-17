import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show GameTagCreateBloc, GameTagFormBloc, ListLoaded, TagListBloc;
import 'package:game_oclock/components/create_edit_form.dart';
import 'package:game_oclock/constants/form_validators.dart';
import 'package:game_oclock/models/models.dart'
    show GameTag, GameTagFormData, ListSearch, SearchDTO;
import 'package:game_oclock/shared/selectors/tag_selector.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class GameTagCreateForm extends StatelessWidget {
  const GameTagCreateForm({super.key, required this.gameId});

  final String gameId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameTagFormBloc(
            formGroup: GameTagFormData(
              gameId: TextEditingController(text: gameId),
              tagId: TextEditingController(),
            ),
          ),
        ),
        BlocProvider(create: (_) => GameTagCreateBloc()),
        BlocProvider(
          create: (_) => TagListBloc()
            ..add(
              // Requires search to be loaded
              ListLoaded(
                search: ListSearch(name: 'default', search: SearchDTO()),
              ),
            ),
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
            fieldsBuilder: (final context, final formGroup, _) =>
                _fieldsCreateBuilder(context, formGroup),
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final GameTagFormData formGroup,
) {
  return Column(
    children: <Widget>[
      TagSelectorBuilder(
        controller: formGroup.tagId,
        validator: (final value) => notEmptyValidator(context, value),
        decoration: InputDecoration(labelText: context.localize().tagLabel),
      ),
    ],
  );
}
