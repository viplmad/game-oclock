import 'package:flutter_bloc/flutter_bloc.dart';

import 'action.dart'
    show
        ActionEvent,
        ActionFinal,
        ActionInProgress,
        ActionInitial,
        ActionStarted,
        ActionState;

abstract class FunctionActionBloc<E, S>
    extends Bloc<ActionEvent<E>, ActionState<S>> {
  FunctionActionBloc() : super(ActionInitial<S>()) {
    on<ActionStarted<E>>(
      (final event, final emit) async =>
          await onActionStarted(event.data, emit),
    );
  }

  Future<void> onActionStarted(
    final E event,
    final Emitter<ActionState<S>> emit,
  ) async {
    if (state is ActionInitial<S>) {
      emit(ActionInProgress<S>(data: null));
      emit(await doAction(event, null));
    } else if (state is ActionFinal<S>) {
      final lastData = (state as ActionFinal<S>).data;
      emit(ActionInProgress<S>(data: lastData));

      emit(await doAction(event, lastData));
    }
  }

  Future<ActionState<S>> doAction(final E event, final S? lastData);
}

abstract class ProducerActionBloc<S> extends FunctionActionBloc<void, S> {}

abstract class ConsumerActionBloc<E> extends FunctionActionBloc<E, void> {}
