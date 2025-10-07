import 'package:flutter/material.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show FormData, User, UserChangePassword;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class UserFormData extends FormData<User> {
  final TextEditingController username;
  final TextEditingController password;
  final BoolEditingController admin;

  UserFormData({
    required this.username,
    required this.password,
    required this.admin,
  });

  @override
  void setValues(final User? data) {
    username.setValue(data?.username);
    password.setValue(data?.password);
    admin.setValue(data?.roles.contains('ROLE_ADMIN')); // TODO
  }
}

class UserChangePasswordFormData extends FormData<UserChangePassword> {
  final TextEditingController newPassword;
  final TextEditingController currentPassword;

  UserChangePasswordFormData({
    required this.newPassword,
    required this.currentPassword,
  });

  @override
  void setValues(final UserChangePassword? data) {
    // Edit not allowed
  }
}
