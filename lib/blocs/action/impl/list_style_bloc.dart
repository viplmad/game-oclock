import 'package:game_oclock/models/models.dart' show ListStyle;

import '../action.dart' show ActionFinal, ActionSuccess, FunctionActionBloc;

class ListStyleBloc extends FunctionActionBloc<ListStyle, ListStyle> {
  @override
  Future<ActionFinal<ListStyle, ListStyle>> doAction(
    final ListStyle event,
    final ListStyle? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
