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
import 'package:game_oclock/models/models.dart' show NewUser, UserFormData;
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class UserCreateForm extends StatelessWidget {
  const UserCreateForm({super.key, required this.initialName});

  final String? initialName;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserFormBloc(
            data: UserFormData(
              username: FormControl<String>(
                value: initialName,
                validators: [NotEmptyValidator(context)],
              ),
              password: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              passwordConfirmation: FormControl<String>(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            NewUser,
            UserDTO,
            String,
            UserFormData,
            UserFormBloc,
            UserCreateBloc
          >(
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
            data: UserFormData(
              username: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              password: FormControl<String>(),
              passwordConfirmation: FormControl<String>(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserUpdateBloc(service: RepositoryProvider.of(context), id: id),
        ),
        BlocProvider(
          create: (_) =>
              UserGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            NewUserDTO,
            UserDTO,
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
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        formControl: formGroup.username,
        label: context.localize().usernameLabel,
        readOnly: readOnly,
      ),
      SimpleConfirmationTextFormField(
        formControl: formGroup.password,
        confirmationFormControl: formGroup.passwordConfirmation,
        label: context.localize().passwordLabel,
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
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        formControl: formGroup.username,
        label: context.localize().usernameLabel,
        readOnly: readOnly,
      ),
    ],
  );
}
