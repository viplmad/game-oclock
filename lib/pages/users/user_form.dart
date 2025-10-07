import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        UserCreateBloc,
        UserFormBloc,
        UserGetBloc,
        UserUpdateBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show User, UserFormData;
import 'package:game_oclock/utils/localisation_extension.dart';

class UserCreateForm extends StatelessWidget {
  const UserCreateForm({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserFormBloc(
            formGroup: UserFormData(
              username: TextEditingController(),
              password: TextEditingController(),
              admin: BoolEditingController(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<User, UserFormData, UserFormBloc, UserCreateBloc>(
            title: context.localize().creatingTitle,
            fieldsBuilder: _fieldsCreateBuilder,
          ),
    );
  }
}

class UserEditForm extends StatelessWidget {
  const UserEditForm({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserFormBloc(
            formGroup: UserFormData(
              username: TextEditingController(),
              password: TextEditingController(),
              admin: BoolEditingController(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserUpdateBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            User,
            UserFormData,
            UserFormBloc,
            UserGetBloc,
            UserUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsEditBuilder,
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final UserFormData formGroup,
  final bool readOnly,
) {
  return Column(
    children: <Widget>[
      SimpleTextFormField(
        controller: formGroup.username,
        label: context.localize().usernameLabel,
        required: true,
        readOnly: readOnly,
      ),
      SimpleConfirmationTextFormField(
        controller: formGroup.password,
        label: context.localize().passwordLabel,
        required: true,
        readOnly: readOnly,
      ),
      SimpleBoolFormField(
        controller: formGroup.admin,
        label: context.localize().adminLabel,
        readOnly: readOnly,
      ),
    ],
  );
}

Widget _fieldsEditBuilder(
  final BuildContext context,
  final UserFormData formGroup,
  final bool readOnly,
) {
  return Column(
    children: <Widget>[
      SimpleTextFormField(
        controller: formGroup.username,
        label: context.localize().usernameLabel,
        required: true,
        readOnly: readOnly,
      ),
      SimpleBoolFormField(
        controller: formGroup.admin,
        label: context.localize().adminLabel,
        readOnly: readOnly,
      ),
    ],
  );
}
