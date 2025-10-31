import 'package:game_oclock/models/models.dart' show GameSession;
import 'package:game_oclock/services/services.dart' show GameSessionService;

import '../action.dart' show ActionFinal, ActionSuccess, IdentityActionBloc;

class GameSessionCreateBloc extends IdentityActionBloc<GameSession> {
  GameSessionCreateBloc({required this.service});

  final GameSessionService service;

  @override
  Future<ActionFinal<GameSession, GameSession>> doAction(
    final GameSession event,
    final GameSession? lastData,
  ) async {
    final data = await service.create(event);
    return ActionSuccess(data: data, event: event);
  }
}

class GameSessionSelectBloc extends IdentityActionBloc<GameSession?> {
  @override
  Future<ActionFinal<GameSession?, GameSession?>> doAction(
    final GameSession? event,
    final GameSession? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
