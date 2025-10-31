import 'package:game_oclock/blocs/blocs.dart';
import 'package:game_oclock/models/models.dart' show GameTag;
import 'package:game_oclock/services/services.dart' show GameService;

class GameTagCreateBloc extends IdentityActionBloc<GameTag> {
  GameTagCreateBloc({required this.service});

  final GameService service;

  @override
  Future<ActionFinal<GameTag, GameTag>> doAction(
    final GameTag event,
    final GameTag? lastData,
  ) async {
    await service.addTag(event.gameId, event.tagId);
    return ActionSuccess(data: event, event: event);
  }
}
