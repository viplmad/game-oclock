import '../action.dart' show ActionFinal, ActionSuccess, IdentityActionBloc;

class CalendarDaySelectBloc extends IdentityActionBloc<DateTime> {
  @override
  Future<ActionFinal<DateTime, DateTime>> doAction(
    final DateTime event,
    final DateTime? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}

class CalendarDayFocusBloc extends IdentityActionBloc<DateTime> {
  @override
  Future<ActionFinal<DateTime, DateTime>> doAction(
    final DateTime event,
    final DateTime? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
