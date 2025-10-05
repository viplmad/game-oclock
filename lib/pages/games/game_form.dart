import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ExternalGameListBloc,
        ListLoaded,
        UserGameCreateBloc,
        UserGameFormBloc,
        UserGameGetBloc,
        UserGameUpdateBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show ListSearch, SearchDTO, UserGame, UserGameFormData, gameStatusOptions;
import 'package:game_oclock/shared/selectors/external_game_selector.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class UserGameCreateForm extends StatelessWidget {
  const UserGameCreateForm({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserGameFormBloc(
            formGroup: UserGameFormData(
              title: TextEditingController(),
              edition: TextEditingController(),
              status: TextEditingController(),
              rating: ScalarNumberEditingController(),
              notes: TextEditingController(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              ExternalGameListBloc(igdbService: RepositoryProvider.of(context))
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
            UserGame,
            UserGameFormData,
            UserGameFormBloc,
            UserGameCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: (final context, final formGroup, _) =>
                _fieldsCreateBuilder(context, formGroup),
          ),
    );
  }
}

class UserGameEditForm extends StatelessWidget {
  const UserGameEditForm({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserGameFormBloc(
            formGroup: UserGameFormData(
              title: TextEditingController(),
              edition: TextEditingController(),
              status: TextEditingController(),
              rating: ScalarNumberEditingController(),
              notes: TextEditingController(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameUpdateBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            UserGame,
            UserGameFormData,
            UserGameFormBloc,
            UserGameGetBloc,
            UserGameUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsEditBuilder,
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final UserGameFormData formGroup,
) {
  return Column(
    children: <Widget>[
      ExternalGameSelectorBuilder(
        controller: formGroup.title,
        label: context.localize().titleLabel,
        required: true,
      ),
      SimpleTextFormField(
        controller: formGroup.edition,
        label: context.localize().editionLabel,
      ),
      SimpleChoiceFormField(
        controller: formGroup.status,
        label: context.localize().statusLabel,
        options: gameStatusOptions,
      ),
      SimpleRatingFormField(
        controller: formGroup.rating,
        label: context.localize().ratingLabel,
        color: const Color(0xA0B71C1C),
        borderColor: Colors.redAccent,
      ),
      SimpleTextFormField(
        controller: formGroup.notes,
        label: context.localize().notesLabel,
        multiline: true,
      ),
    ],
  );
}

Widget _fieldsEditBuilder(
  final BuildContext context,
  final UserGameFormData formGroup,
  final bool readOnly,
) {
  return Column(
    children: <Widget>[
      SimpleTextFormField(
        controller: formGroup.title,
        label: context.localize().titleLabel,
        required: true,
        readOnly: readOnly,
      ),
      SimpleTextFormField(
        controller: formGroup.edition,
        label: context.localize().editionLabel,
        readOnly: readOnly,
      ),
      SimpleChoiceFormField(
        controller: formGroup.status,
        label: context.localize().statusLabel,
        options: gameStatusOptions,
      ),
      SimpleRatingFormField(
        controller: formGroup.rating,
        label: context.localize().ratingLabel,
        readOnly: readOnly,
        color: const Color(0xA0B71C1C),
        borderColor: Colors.redAccent,
      ),
      SimpleTextFormField(
        controller: formGroup.notes,
        label: context.localize().notesLabel,
        readOnly: readOnly,
        multiline: true,
      ),
    ],
  );
}
