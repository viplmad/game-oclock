import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show Login;

import 'action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class LoginGetBloc extends FunctionActionBloc<String, Login?> {
  @override
  Future<ActionFinal<Login?>> doAction(
    final String event,
    final Login? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO search in local storage
    return ActionSuccess(data: mockLogin());
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
