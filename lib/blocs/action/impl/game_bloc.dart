import 'package:game_oclock/models/models.dart' show UserGame;
import 'package:game_oclock/services/services.dart' show GameService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class UserGameGetBloc extends FunctionActionBloc<String, UserGame> {
  UserGameGetBloc({required this.service});

  final GameService service;

  @override
  Future<UserGame> doAction(final String event, final UserGame? lastData) =>
      service.get(event);
}

class UserGameCreateBloc extends IdentityActionBloc<UserGame> {
  UserGameCreateBloc({required this.service});

  final GameService service;

  @override
  Future<UserGame> doAction(final UserGame event, final UserGame? lastData) =>
      service.create(event);
}

class UserGameUpdateBloc extends ConsumerActionBloc<UserGame> {
  UserGameUpdateBloc({required this.service});

  final GameService service;

  @override
  Future<void> doAction(final UserGame event, final void lastData) =>
      service.update(event);
}

class UserGameDeleteBloc extends ConsumerActionBloc<UserGame> {
  UserGameDeleteBloc({required this.service});

  final GameService service;

  @override
  Future<void> doAction(final UserGame event, final void lastData) =>
      service.delete(event.id);
}

class UserGameSelectBloc extends IdentityActionBloc<UserGame?> {
  @override
  Future<UserGame?> doAction(
    final UserGame? event,
    final UserGame? lastData,
  ) async => event;
}
