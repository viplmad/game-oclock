import 'package:game_oclock/models/models.dart' show GameSession;
import 'package:game_oclock/services/services.dart' show GameSessionService;

import '../action.dart' show IdentityActionBloc;

class GameSessionCreateBloc extends IdentityActionBloc<GameSession> {
  GameSessionCreateBloc({required this.service});

  final GameSessionService service;

  @override
  Future<GameSession> doAction(
    final GameSession event,
    final GameSession? lastData,
  ) => service.create(event);
}

class GameSessionSelectBloc extends IdentityActionBloc<GameSession?> {
  @override
  Future<GameSession?> doAction(
    final GameSession? event,
    final GameSession? lastData,
  ) async => event;
}
