import 'package:game_oclock/blocs/blocs.dart';
import 'package:game_oclock/models/models.dart' show GameAvailable;
import 'package:game_oclock/services/services.dart' show GameService;

class GameAvailableCreateBloc extends IdentityActionBloc<GameAvailable> {
  GameAvailableCreateBloc({required this.service});

  final GameService service;

  @override
  Future<GameAvailable> doAction(
    final GameAvailable event,
    final GameAvailable? lastData,
  ) => service
      .addAvailability(event.gameId, event.locationId, event.date)
      .then((_) => event);
}
