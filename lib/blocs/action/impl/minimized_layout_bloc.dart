import '../action.dart' show IdentityActionBloc;

class MinimizedLayoutBloc extends IdentityActionBloc<bool> {
  @override
  Future<bool> doAction(bool event, bool? lastData) async => event;
}
