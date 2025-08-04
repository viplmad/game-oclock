import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, Login;

import 'form.dart' show FormBloc;

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
    host.value = host.value.copyWith(text: login?.host);
    username.value = username.value.copyWith(text: login?.username);
    password.value = password.value.copyWith(text: login?.password);
  }
}

class LoginFormBloc extends FormBloc<LoginFormData, Login> {
  LoginFormBloc({required super.formGroup});

  @override
  Login fromDynamicMap(final LoginFormData values) {
    return Login(
      host: values.host.value.text,
      username: values.username.value.text,
      password: values.password.value.text,
    );
  }
}
