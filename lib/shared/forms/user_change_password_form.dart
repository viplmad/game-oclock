import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show UserChangePasswordBloc, UserChangePasswordFormBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show UserChangePassword, UserChangePasswordFormData;
import 'package:game_oclock/utils/localisation_extension.dart';

class UserChangePasswordForm extends StatelessWidget {
  const UserChangePasswordForm({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserChangePasswordFormBloc(
            formGroup: UserChangePasswordFormData(
              currentPassword: TextEditingController(),
              newPassword: TextEditingController(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserChangePasswordBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            UserChangePassword,
            UserChangePasswordFormData,
            UserChangePasswordFormBloc,
            UserChangePasswordBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: _fieldsCreateBuilder,
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final UserChangePasswordFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      SimpleObscuredTextFormField(
        controller: formGroup.currentPassword,
        label: context.localize().currentPasswordLabel,
        required: true,
        readOnly: readOnly,
      ),
      SimpleConfirmationTextFormField(
        controller: formGroup.newPassword,
        label: context.localize().newPasswordLabel,
        required: true,
        readOnly: readOnly,
      ),
    ],
  );
}
