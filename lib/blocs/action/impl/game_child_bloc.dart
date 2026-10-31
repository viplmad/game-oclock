import 'package:game_oclock/models/models.dart' show GameChild;
import 'package:game_oclock/services/services.dart' show GameService;
import 'package:game_oclock_client/api.dart';

import '../action.dart' show FunctionActionBloc;

class GameChildCreateBloc
    extends FunctionActionBloc<GameChild, (String, String, int?)> {
  GameChildCreateBloc({required this.service});

  final GameService service;

  @override
  Future<(String, String, int?)> doAction(
    GameChild event,
    (String, String, int?)? lastData,
  ) => service
      .update(
        event.childGameId,
        NewMediaDTO(
          media: NewMediaValue(
            parentId: event.parentGameId,
            parentOrder: event.order,
          ),
          state: NewMediaStateDTO(),
        ),
      )
      .then((_) => (event.parentGameId, event.childGameId, event.order));
}
