import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show UserGame;

import 'action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class UserGameGetBloc extends FunctionActionBloc<String, UserGame> {
  @override
  Future<ActionFinal<UserGame>> doAction(
    final String event,
    final UserGame? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(data: mockUserGame());
  }
}

class UserGameCreateBloc extends ConsumerActionBloc<UserGame> {
  @override
  Future<ActionFinal<void>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 5));
    return ActionSuccess.empty();
  }
}

class UserGameUpdateBloc extends ConsumerActionBloc<UserGame> {
  @override
  Future<ActionFinal<void>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty();
  }
}

class UserGameSelectBloc extends FunctionActionBloc<UserGame?, UserGame?> {
  @override
  Future<ActionFinal<UserGame?>> doAction(
    final UserGame? event,
    final UserGame? lastData,
  ) async {
    return ActionSuccess(data: event);
  }
}
