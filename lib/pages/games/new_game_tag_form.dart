import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GameTagCreateBloc,
        GameTagFormBloc,
        ListLoaded,
        TagCreateBloc,
        TagListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
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
        BlocProvider(
          create: (_) =>
              GameTagCreateBloc(service: RepositoryProvider.of(context)),
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
        label: context.localize().tagLabel,
        required: true,
      ),
    ],
  );
}
