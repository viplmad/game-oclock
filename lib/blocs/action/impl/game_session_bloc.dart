import 'package:game_oclock/models/models.dart' show GameSession;
import 'package:game_oclock/services/services.dart' show GameSessionService;

import '../action.dart' show ActionFinal, ActionSuccess, ConsumerActionBloc;

class GameSessionCreateBloc extends ConsumerActionBloc<GameSession> {
  GameSessionCreateBloc({required this.service});

  final GameSessionService service;

  @override
  Future<ActionFinal<void, GameSession>> doAction(
    final GameSession event,
    final void lastData,
  ) async {
    await service.create(event);
    return ActionSuccess.consumer(event);
  }
}
