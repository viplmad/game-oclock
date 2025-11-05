import '../action.dart' show IdentityActionBloc;

class MinimizedLayoutBloc extends IdentityActionBloc<bool> {
  @override
  Future<bool> doAction(final bool event, final bool? lastData) async => event;
}
