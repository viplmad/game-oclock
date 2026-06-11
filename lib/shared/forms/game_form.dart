import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        UserGameCreateBloc,
        UserGameExternalFormBloc,
        UserGameFormBloc,
        UserGameGetBloc,
        UserGameUpdateBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/models/models.dart'
    show UserGameExternalFormData, UserGameFormData, gameStatusOptions;
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class UserGameExternalCreateForm extends StatelessWidget {
  const UserGameExternalCreateForm({super.key, required this.externalId});

  final ExternalMediaIdDTO externalId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserGameExternalFormBloc(
            data: UserGameExternalFormData(
              extenalSource: FormControl<String>(
                value: externalId.source_,
                validators: [NotEmptyValidator(context)],
              ),
              externalId: FormControl<String>(
                value: externalId.id,
                validators: [NotEmptyValidator(context)],
              ),
              status: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              rating: FormControl<int>(),
              notes: FormControl<String>(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            NewMediaDTO,
            MediaDTO,
            String,
            UserGameExternalFormData,
            UserGameExternalFormBloc,
            UserGameCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: (final context, final formGroup, final readOnly) =>
                _fieldsCreateExternalBuilder(
                  context,
                  externalId,
                  formGroup,
                  readOnly,
                ),
          ),
    );
  }
}

Widget _fieldsCreateExternalBuilder(
  final BuildContext context,
  final ExternalMediaIdDTO externalId,
  final UserGameExternalFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      TextLabel(label: context.localize().idLabel, value: externalId.source_),
      TextLabel(label: context.localize().idLabel, value: externalId.id),
      SimpleChoiceFormField(
        formControl: formGroup.status,
        label: context.localize().statusLabel,
        readOnly: readOnly,
        options: gameStatusOptions,
      ),
      SimpleRatingFormField(
        formControl: formGroup.rating,
        label: context.localize().ratingLabel,
        readOnly: readOnly,
        color: CommonColors.rating,
      ),
      SimpleTextFormField(
        formControl: formGroup.notes,
        label: context.localize().notesLabel,
        readOnly: readOnly,
        multiline: true,
      ),
    ],
  );
}

class UserGameCreateForm extends StatelessWidget {
  const UserGameCreateForm({super.key, this.initialTitle});

  final String? initialTitle;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserGameFormBloc(
            data: UserGameFormData(
              title: FormControl<String>(
                value: initialTitle,
                validators: [NotEmptyValidator(context)],
              ),
              edition: FormControl<String>(),
              releaseDate: FormControl<DateTime>(),
              status: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              rating: FormControl<int>(),
              notes: FormControl<String>(),
              genres: FormArray<String>([]),
              series: FormArray<String>([]),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            NewMediaDTO,
            MediaDTO,
            String,
            UserGameFormData,
            UserGameFormBloc,
            UserGameCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: _fieldsBuilder,
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
            data: UserGameFormData(
              title: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              edition: FormControl<String>(),
              releaseDate: FormControl<DateTime>(),
              status: FormControl<String>(),
              rating: FormControl<int>(),
              notes: FormControl<String>(),
              genres: FormArray<String>([]),
              series: FormArray<String>([]),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => UserGameUpdateBloc(
            service: RepositoryProvider.of(context),
            id: id,
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            NewMediaDTO,
            MediaDTO,
            UserGameFormData,
            UserGameFormBloc,
            UserGameGetBloc,
            UserGameUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final UserGameFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        formControl: formGroup.title,
        label: context.localize().titleLabel,
        readOnly: readOnly,
      ),
      SimpleTextFormField(
        formControl: formGroup.edition,
        label: context.localize().editionLabel,
        readOnly: readOnly,
      ),
      SimpleDateFormField(
        formControl: formGroup.releaseDate,
        label: context.localize().releaseDateLabel,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ),
      SimpleChoiceFormField(
        formControl: formGroup.status,
        label: context.localize().statusLabel,
        readOnly: readOnly,
        options: gameStatusOptions,
      ),
      SimpleRatingFormField(
        formControl: formGroup.rating,
        label: context.localize().ratingLabel,
        readOnly: readOnly,
        color: CommonColors.rating,
      ),
      SimpleTextFormField(
        formControl: formGroup.notes,
        label: context.localize().notesLabel,
        readOnly: readOnly,
        multiline: true,
      ),
      SimpleMultipleSelectFormField(
        formArray: formGroup.genres,
        label: context.localize().genresLabel,
        readOnly: readOnly,
      ),
      SimpleMultipleSelectFormField(
        formArray: formGroup.series,
        label: context.localize().seriesLabel,
        readOnly: readOnly,
      ),
    ],
  );
}
