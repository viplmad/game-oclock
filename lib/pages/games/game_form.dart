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
          const CreateEditFormBuilder<
            UserGame,
            UserGameFormData,
            UserGameFormBloc,
            UserGameGetBloc,
            UserGameCreateBloc,
            UserGameUpdateBloc
          >(title: 'Creating', create: true, fieldsBuilder: _fieldsBuilder),
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
          const CreateEditFormBuilder<
            UserGame,
            UserGameFormData,
            UserGameFormBloc,
            UserGameGetBloc,
            UserGameCreateBloc,
            UserGameUpdateBloc
          >(title: 'Editing', create: false, fieldsBuilder: _fieldsBuilder),
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
        validator: notEmptyValidator,
        decoration: const InputDecoration(
          labelText: 'Title', // TODO
        ),
      ),
      TextFormField(
        controller: formGroup.edition,
        readOnly: readOnly,
        decoration: const InputDecoration(
          labelText: 'Edition', // TODO
        ),
      ),
      TextFormField(
        controller: formGroup.status,
        readOnly: readOnly,
        decoration: const InputDecoration(
          labelText: 'Status', // TODO
        ),
      ),
      TextFormField(
        controller: formGroup.rating,
        readOnly: readOnly,
        decoration: const InputDecoration(
          labelText: 'Rating', // TODO
        ),
      ),
      TextFormField(
        controller: formGroup.notes,
        readOnly: readOnly,
        decoration: const InputDecoration(
          labelText: 'Notes', // TODO
        ),
      ),
    ],
  );
}
