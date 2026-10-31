import 'package:game_oclock/models/models.dart' show GamePlaythrough;
import 'package:game_oclock/services/services.dart' show GameService;

import '../action.dart' show FunctionActionBloc;

class GamePlaythroughCreateBloc
    extends FunctionActionBloc<GamePlaythrough, (String, String)> {
  GamePlaythroughCreateBloc({required this.service});

  final GameService service;

  @override
  Future<(String, String)> doAction(
    GamePlaythrough event,
    (String, String)? lastData,
  ) => service
      .addPlaythrough(event.gameId, event.playthroughId)
      .then((_) => (event.gameId, event.playthroughId));
}
