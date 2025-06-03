import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:game_oclock/models/models.dart' show FormData;

import 'action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class Login extends Equatable {
  final String host;
  final String username;
  final String password;

  const Login({
    required this.host,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [host, username];
}

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

class LoginGetBloc extends FunctionActionBloc<String, Login?> {
  @override
  Future<ActionFinal<Login?>> doAction(
    final String event,
    final Login? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO search in local storage
    return const ActionSuccess(
      data: Login(
        host: 'http://localhost:8080',
        username: 'viplmad',
        password: '',
      ),
    );
  }
}

class LoginSaveBloc extends ConsumerActionBloc<Login> {
  @override
  Future<ActionFinal<void>> doAction(
    final Login event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty();
  }
}
