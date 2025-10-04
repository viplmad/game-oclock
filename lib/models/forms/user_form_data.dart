import 'package:flutter/material.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show FormData, User;
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
  void setValues(final User? userGame) {
    username.setValue(userGame?.username);
    password.setValue(userGame?.password);
    admin.setValue(userGame?.roles.contains('ROLE_ADMIN')); // TODO
  }
}
