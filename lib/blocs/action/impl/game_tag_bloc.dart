import 'package:game_oclock/models/models.dart' show GameTag;
import 'package:game_oclock/services/services.dart' show GameService;

import '../action.dart' show ActionFinal, ActionSuccess, ConsumerActionBloc;

class GameTagCreateBloc extends ConsumerActionBloc<GameTag> {
  GameTagCreateBloc({required this.service});

  final GameService service;

  @override
  Future<ActionFinal<void, GameTag>> doAction(
    final GameTag event,
    final void lastData,
  ) async {
    await service.addTag(event.gameId, event.tagId);
    return ActionSuccess.consumer(event);
  }
}
