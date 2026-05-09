import 'package:game_oclock/models/models.dart' show GameAvailable;
import 'package:game_oclock/services/services.dart' show GameService;

import '../action.dart' show FunctionActionBloc;

class GameAvailableCreateBloc
    extends FunctionActionBloc<GameAvailable, (String, String)> {
  GameAvailableCreateBloc({required this.service});

  final GameService service;

  @override
  Future<(String, String)> doAction(
    final GameAvailable event,
    final (String, String)? lastData,
  ) => service
      .addAvailability(event.gameId, event.locationId, event.date)
      .then((_) => (event.gameId, event.locationId));
}
