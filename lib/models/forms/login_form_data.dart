import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, Login;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class LoginFormData extends FormData<Login> {
  final TextEditingController host;
  final TextEditingController username;
  final TextEditingController password;

  LoginFormData({
    required this.host,
    required this.username,
    required this.password,
  });

  @override
  void setValues(final Login? login) {
    host.setValue(login?.host);
    username.setValue(login?.username);
    password.setValue(login?.password);
  }
}
