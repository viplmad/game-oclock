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
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/models/models.dart'
    show ListSearch, SearchDTO, UserGame, UserGameFormData, gameStatusOptions;
import 'package:game_oclock/shared/selectors/external_game_selector.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class UserGameCreateForm extends StatelessWidget {
  const UserGameCreateForm({super.key, this.initialTitle});

  final String? initialTitle;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserGameFormBloc(
            formGroup: UserGameFormData(
              title: TextEditingController(text: initialTitle),
              edition: TextEditingController(),
              releaseDate: DateTimeEditingController(),
              status: TextEditingController(),
              rating: ScalarNumberEditingController(),
              notes: TextEditingController(),
              genres: MultipleTextEditingController(),
              series: MultipleTextEditingController(),
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
            fieldsBuilder: _fieldsCreateBuilder,
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
              releaseDate: DateTimeEditingController(),
              status: TextEditingController(),
              rating: ScalarNumberEditingController(),
              notes: TextEditingController(),
              genres: MultipleTextEditingController(),
              series: MultipleTextEditingController(),
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
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      ExternalGameSelectorBuilder(
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
      SimpleDateFormField(
        controller: formGroup.releaseDate,
        label: context.localize().releaseDateLabel,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ),
      SimpleChoiceFormField(
        controller: formGroup.status,
        label: context.localize().statusLabel,
        required: true,
        readOnly: readOnly,
        options: gameStatusOptions,
      ),
      SimpleRatingFormField(
        controller: formGroup.rating,
        label: context.localize().ratingLabel,
        readOnly: readOnly,
        color: CommonColors.ratingColor,
      ),
      SimpleTextFormField(
        controller: formGroup.notes,
        label: context.localize().notesLabel,
        readOnly: readOnly,
        multiline: true,
      ),
      SimpleMultipleSelectFormField(
        controller: formGroup.genres,
        label: context.localize().genresLabel,
        readOnly: readOnly,
      ),
      SimpleMultipleSelectFormField(
        controller: formGroup.series,
        label: context.localize().seriesLabel,
        readOnly: readOnly,
      ),
    ],
  );
}

Widget _fieldsEditBuilder(
  final BuildContext context,
  final UserGameFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
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
      SimpleDateFormField(
        controller: formGroup.releaseDate,
        label: context.localize().releaseDateLabel,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ),
      SimpleChoiceFormField(
        controller: formGroup.status,
        label: context.localize().statusLabel,
        required: true,
        readOnly: readOnly,
        options: gameStatusOptions,
      ),
      SimpleRatingFormField(
        controller: formGroup.rating,
        label: context.localize().ratingLabel,
        readOnly: readOnly,
        color: CommonColors.ratingColor,
      ),
      SimpleTextFormField(
        controller: formGroup.notes,
        label: context.localize().notesLabel,
        readOnly: readOnly,
        multiline: true,
      ),
      SimpleMultipleSelectFormField(
        controller: formGroup.genres,
        label: context.localize().genresLabel,
        readOnly: readOnly,
      ),
      SimpleMultipleSelectFormField(
        controller: formGroup.series,
        label: context.localize().seriesLabel,
        readOnly: readOnly,
      ),
    ],
  );
}
