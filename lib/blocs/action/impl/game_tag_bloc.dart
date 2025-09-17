import 'package:game_oclock/models/models.dart' show GameTag;

import '../action.dart' show ActionFinal, ActionSuccess, ConsumerActionBloc;

class GameTagCreateBloc extends ConsumerActionBloc<GameTag> {
  @override
  Future<ActionFinal<void, GameTag>> doAction(
    final GameTag event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 5));
    return ActionSuccess.empty(event);
  }
}
