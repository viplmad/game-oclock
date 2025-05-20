import 'action.dart' show ActionFinal, ActionSuccess, FunctionActionBloc;

class MinimizedLayoutBloc extends FunctionActionBloc<bool, bool> {
  @override
  Future<ActionFinal<bool>> doAction(
    final bool event,
    final bool? lastData,
  ) async {
    return ActionSuccess(data: event);
  }
}
