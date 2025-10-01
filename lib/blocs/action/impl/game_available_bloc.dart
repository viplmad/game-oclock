import 'package:game_oclock/models/models.dart' show GameAvailable;
import 'package:game_oclock/services/services.dart' show GameService;

import '../action.dart' show ActionFinal, ActionSuccess, ConsumerActionBloc;

class GameAvailableCreateBloc extends ConsumerActionBloc<GameAvailable> {
  GameAvailableCreateBloc({required this.service});

  final GameService service;

  @override
  Future<ActionFinal<void, GameAvailable>> doAction(
    final GameAvailable event,
    final void lastData,
  ) async {
    await service.addAvailability(event.gameId, event.locationId, event.date);
    return ActionSuccess.consumer(event);
  }
}
