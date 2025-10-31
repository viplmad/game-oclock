import 'package:game_oclock/blocs/blocs.dart';
import 'package:game_oclock/models/models.dart' show GameAvailable;
import 'package:game_oclock/services/services.dart' show GameService;

class GameAvailableCreateBloc extends IdentityActionBloc<GameAvailable> {
  GameAvailableCreateBloc({required this.service});

  final GameService service;

  @override
  Future<ActionFinal<GameAvailable, GameAvailable>> doAction(
    final GameAvailable event,
    final GameAvailable? lastData,
  ) async {
    await service.addAvailability(event.gameId, event.locationId, event.date);
    return ActionSuccess(data: event, event: event);
  }
}
