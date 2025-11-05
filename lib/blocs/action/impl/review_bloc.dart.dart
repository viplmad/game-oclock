import '../action.dart' show IdentityActionBloc;

class ReviewYearSelectBloc extends IdentityActionBloc<int?> {
  @override
  Future<int?> doAction(final int? event, final int? lastData) async => event;
}
