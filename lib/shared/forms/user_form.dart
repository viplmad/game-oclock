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
                validators: [Validators.required],
              ),
              password: FormControl<String>(validators: [Validators.required]),
              passwordConfirmation: FormControl<String>(),
              admin: FormControl<bool>(),
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
            data: UserFormData(
              username: FormControl<String>(validators: [Validators.required]),
              password: FormControl<String>(),
              passwordConfirmation: FormControl<String>(),
              admin: FormControl<bool>(),
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
      SimpleBoolFormField(
        formControl: formGroup.admin,
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
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        formControl: formGroup.username,
        label: context.localize().usernameLabel,
        readOnly: readOnly,
      ),
      SimpleBoolFormField(
        formControl: formGroup.admin,
        label: context.localize().adminLabel,
        readOnly: readOnly,
      ),
    ],
  );
}
