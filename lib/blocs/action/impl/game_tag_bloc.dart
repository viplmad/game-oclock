import 'package:game_oclock/blocs/blocs.dart';
import 'package:game_oclock/models/models.dart' show GameTag;
import 'package:game_oclock/services/services.dart' show GameService;

class GameTagCreateBloc extends IdentityActionBloc<GameTag> {
  GameTagCreateBloc({required this.service});

  final GameService service;

  @override
  Future<GameTag> doAction(final GameTag event, final GameTag? lastData) =>
      service.addTag(event.gameId, event.tagId).then((_) => event);
}
