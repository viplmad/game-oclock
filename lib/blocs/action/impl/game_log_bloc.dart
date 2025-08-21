import '../action.dart' show ActionFinal, ActionSuccess, FunctionActionBloc;

class GameLogSelectBloc extends FunctionActionBloc<DateTime?, DateTime?> {
  // TODO
  @override
  Future<ActionFinal<DateTime?, DateTime?>> doAction(
    final DateTime? event,
    final DateTime? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
