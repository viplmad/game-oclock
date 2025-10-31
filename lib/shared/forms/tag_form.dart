import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionStarted, TagCreateBloc, TagFormBloc, TagGetBloc, TagUpdateBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show Tag, TagFormData;
import 'package:game_oclock/utils/localisation_extension.dart';

class TagCreateForm extends StatelessWidget {
  const TagCreateForm({super.key, this.initialName});

  final String? initialName;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TagFormBloc(
            formGroup: TagFormData(
              name: TextEditingController(text: initialName),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => TagCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child: CreateFormBuilder<Tag, TagFormData, TagFormBloc, TagCreateBloc>(
        title: context.localize().creatingTitle,
        fieldsBuilder: _fieldsBuilder,
      ),
    );
  }
}

class TagEditForm extends StatelessWidget {
  const TagEditForm({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TagFormBloc(
            formGroup: TagFormData(name: TextEditingController()),
          ),
        ),
        BlocProvider(
          create: (_) => TagUpdateBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              TagGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            Tag,
            TagFormData,
            TagFormBloc,
            TagGetBloc,
            TagUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final TagFormData formGroup,
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
