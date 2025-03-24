import 'action.dart'
    show
        ActionState,
        ActionSuccess,
        ConsumerActionBloc,
        FunctionActionBloc,
        ProducerActionBloc;

class CounterProducerBloc extends ProducerActionBloc<int> {
  @override
  Future<ActionState<int>> doAction(
    final void event,
    final int? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(data: (lastData ?? 0) + 1);
  }
}

class CounterConsumerBloc extends ConsumerActionBloc<String> {
  @override
  Future<ActionState<void>> doAction(
    final String event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty();
  }
}

class CounterFunctionBloc extends FunctionActionBloc<String, int> {
  @override
  Future<ActionState<int>> doAction(
    final String event,
    final int? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(data: (int.tryParse(event) ?? lastData ?? 0) + 1);
  }
}
