import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        PlaythroughCreateBloc,
        PlaythroughFormBloc,
        PlaythroughGetBloc,
        PlaythroughUpdateBloc,
        UserGameCreateBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show Playthrough, PlaythroughFormData;
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PlaythroughCreateForm extends StatelessWidget {
  const PlaythroughCreateForm({super.key, this.initialName});

  final String? initialName;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PlaythroughFormBloc(
            data: PlaythroughFormData(
              name: FormControl<String>(
                value: initialName,
                validators: [NotEmptyValidator(context)],
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              PlaythroughCreateBloc(service: RepositoryProvider.of(context)),
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
            Playthrough,
            PlaythroughFormData,
            PlaythroughFormBloc,
            PlaythroughCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

class PlaythroughEditForm extends StatelessWidget {
  const PlaythroughEditForm({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PlaythroughFormBloc(
            data: PlaythroughFormData(
              name: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              PlaythroughUpdateBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              PlaythroughGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            Playthrough,
            PlaythroughFormData,
            PlaythroughFormBloc,
            PlaythroughGetBloc,
            PlaythroughUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final PlaythroughFormData formGroup,
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
