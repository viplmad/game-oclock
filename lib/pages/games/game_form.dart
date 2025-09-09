import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        UserGameCreateBloc,
        UserGameFormBloc,
        UserGameGetBloc,
        UserGameUpdateBloc;
import 'package:game_oclock/components/create_edit_form.dart';
import 'package:game_oclock/constants/form_validators.dart';
import 'package:game_oclock/models/models.dart' show UserGame, UserGameFormData;
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
              rating: TextEditingController(),
              notes: TextEditingController(),
            ),
          ),
        ),
        BlocProvider(create: (_) => UserGameCreateBloc()),
      ],
      child:
          CreateEditFormBuilder<
            UserGame,
            UserGameFormData,
            UserGameFormBloc,
            UserGameGetBloc,
            UserGameCreateBloc,
            UserGameUpdateBloc
          >(
            title: context.localize().creatingTitle,
            create: true,
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
            formGroup: UserGameFormData(
              title: TextEditingController(),
              edition: TextEditingController(),
              status: TextEditingController(),
              rating: TextEditingController(),
              notes: TextEditingController(),
            ),
          ),
        ),
        BlocProvider(create: (_) => UserGameUpdateBloc()),
        BlocProvider(
          create: (_) => UserGameGetBloc()..add(ActionStarted(data: id)),
        ),
      ],
      child:
          CreateEditFormBuilder<
            UserGame,
            UserGameFormData,
            UserGameFormBloc,
            UserGameGetBloc,
            UserGameCreateBloc,
            UserGameUpdateBloc
          >(
            title: context.localize().editingTitle,
            create: false,
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
  return Column(
    children: <Widget>[
      TextFormField(
        controller: formGroup.title,
        readOnly: readOnly,
        validator: (final value) => notEmptyValidator(context, value),
        decoration: InputDecoration(labelText: context.localize().titleLabel),
      ),
      TextFormField(
        controller: formGroup.edition,
        readOnly: readOnly,
        decoration: InputDecoration(labelText: context.localize().editionLabel),
      ),
      TextFormField(
        controller: formGroup.status,
        readOnly: readOnly,
        decoration: InputDecoration(labelText: context.localize().statusLabel),
      ),
      TextFormField(
        controller: formGroup.rating,
        readOnly: readOnly,
        decoration: InputDecoration(labelText: context.localize().ratingLabel),
      ),
      TextFormField(
        controller: formGroup.notes,
        readOnly: readOnly,
        decoration: InputDecoration(labelText: context.localize().notesLabel),
      ),
    ],
  );
}
