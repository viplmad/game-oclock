import 'package:game_oclock/models/models.dart' show UserGame;
import 'package:game_oclock/services/services.dart' show GameService;

import '../action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class UserGameGetBloc extends FunctionActionBloc<String, UserGame> {
  UserGameGetBloc({required this.service});

  final GameService service;

  @override
  Future<ActionFinal<UserGame, String>> doAction(
    final String event,
    final UserGame? lastData,
  ) async {
    final data = await service.get(event);
    return ActionSuccess(data: data, event: event);
  }
}

class UserGameCreateBloc extends ConsumerActionBloc<UserGame> {
  UserGameCreateBloc({required this.service});

  final GameService service;

  @override
  Future<ActionFinal<void, UserGame>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await service.create(event);
    return ActionSuccess.consumer(event);
  }
}

class UserGameUpdateBloc extends ConsumerActionBloc<UserGame> {
  UserGameUpdateBloc({required this.service});

  final GameService service;

  @override
  Future<ActionFinal<void, UserGame>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await service.update(event);
    return ActionSuccess.consumer(event);
  }
}

class UserGameDeleteBloc extends ConsumerActionBloc<UserGame> {
  UserGameDeleteBloc({required this.service});

  final GameService service;

  @override
  Future<ActionFinal<void, UserGame>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await service.delete(event.id);
    return ActionSuccess.consumer(event);
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
