import 'package:game_oclock/models/models.dart' show DateLocaleConfig;

import '../action.dart' show ActionFinal, ActionSuccess, FunctionActionBloc;

class DateLocaleConfigBloc
    extends FunctionActionBloc<DateLocaleConfig, DateLocaleConfig> {
  @override
  Future<ActionFinal<DateLocaleConfig, DateLocaleConfig>> doAction(
    final DateLocaleConfig event,
    final DateLocaleConfig? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
