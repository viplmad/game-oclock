import '../action.dart' show ActionFinal, ActionSuccess, IdentityActionBloc;

class MinimizedLayoutBloc extends IdentityActionBloc<bool> {
  @override
  Future<ActionFinal<bool, bool>> doAction(
    final bool event,
    final bool? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
