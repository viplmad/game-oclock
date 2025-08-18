import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show UserGame;

import 'action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class UserGameGetBloc extends FunctionActionBloc<String, UserGame> {
  @override
  Future<ActionFinal<UserGame, String>> doAction(
    final String event,
    final UserGame? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(data: mockUserGame(), event: event);
  }
}

class UserGameCreateBloc extends ConsumerActionBloc<UserGame> {
  @override
  Future<ActionFinal<void, UserGame>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 5));
    return ActionSuccess.empty(event);
  }
}

class UserGameUpdateBloc extends ConsumerActionBloc<UserGame> {
  @override
  Future<ActionFinal<void, UserGame>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty(event);
  }
}

class UserGameDeleteBloc extends ConsumerActionBloc<UserGame> {
  @override
  Future<ActionFinal<void, UserGame>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty(event);
  }
}

class UserGameSelectBloc extends FunctionActionBloc<UserGame?, UserGame?> {
  @override
  Future<ActionFinal<UserGame?, UserGame?>> doAction(
    final UserGame? event,
    final UserGame? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
