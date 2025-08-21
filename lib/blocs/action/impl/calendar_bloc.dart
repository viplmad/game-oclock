import '../action.dart' show ActionFinal, ActionSuccess, FunctionActionBloc;

class CalendarDaySelectBloc extends FunctionActionBloc<DateTime, DateTime> {
  @override
  Future<ActionFinal<DateTime, DateTime>> doAction(
    final DateTime event,
    final DateTime? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
