import '../action.dart' show ActionFinal, ActionSuccess, IdentityActionBloc;

class ReviewYearSelectBloc extends IdentityActionBloc<int?> {
  @override
  Future<ActionFinal<int?, int?>> doAction(
    final int? event,
    final int? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
