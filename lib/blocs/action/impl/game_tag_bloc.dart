import 'package:game_oclock/models/models.dart' show GameTag;
import 'package:game_oclock/services/services.dart' show GameService;

import '../action.dart' show FunctionActionBloc;

class GameTagCreateBloc extends FunctionActionBloc<GameTag, (String, String)> {
  GameTagCreateBloc({required this.service});

  final GameService service;

  @override
  Future<(String, String)> doAction(
    final GameTag event,
    final (String, String)? lastData,
  ) => service
      .addTag(event.gameId, event.tagId)
      .then((_) => (event.gameId, event.tagId));
}
