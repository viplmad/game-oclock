import '../action.dart' show IdentityActionBloc;

class CalendarDaySelectBloc extends IdentityActionBloc<DateTime> {
  @override
  Future<DateTime> doAction(
    final DateTime event,
    final DateTime? lastData,
  ) async => event;
}

class CalendarDayFocusBloc extends IdentityActionBloc<DateTime> {
  @override
  Future<DateTime> doAction(
    final DateTime event,
    final DateTime? lastData,
  ) async => event;
}
