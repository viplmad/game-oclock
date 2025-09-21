import 'package:game_oclock/models/models.dart' show Tag;

import '../action.dart' show ActionFinal, ActionSuccess, ConsumerActionBloc;

class TagCreateBloc extends ConsumerActionBloc<Tag> {
  @override
  Future<ActionFinal<void, Tag>> doAction(
    final Tag event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 5));
    return ActionSuccess.empty(event);
  }
}
