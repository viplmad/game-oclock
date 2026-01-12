import 'package:game_oclock/blocs/blocs.dart';
import 'package:game_oclock/models/models.dart' show GamePlaythrough;
import 'package:game_oclock/services/services.dart' show GameService;

class GamePlaythroughCreateBloc extends IdentityActionBloc<GamePlaythrough> {
  GamePlaythroughCreateBloc({required this.service});

  final GameService service;

  @override
  Future<GamePlaythrough> doAction(
    final GamePlaythrough event,
    final GamePlaythrough? lastData,
  ) => service
      .addPlaythrough(event.gameId, event.playthroughId)
      .then((_) => event);
}
