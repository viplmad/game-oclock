import '../action.dart' show ActionFinal, ActionSuccess, FunctionActionBloc;

class ReviewYearSelectBloc extends FunctionActionBloc<int?, int?> {
  @override
  Future<ActionFinal<int?, int?>> doAction(
    final int? event,
    final int? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
