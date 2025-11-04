import 'package:flutter_bloc/flutter_bloc.dart';

import 'action.dart'
    show
        ActionEvent,
        ActionFinal,
        ActionInProgress,
        ActionInitial,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionStored;

abstract class FunctionActionBloc<E, S>
    extends Bloc<ActionEvent<E>, ActionState<S>> {
  FunctionActionBloc() : super(ActionInitial<S>()) {
    on<ActionStored<E>>(
      (final event, final emit) async => await onActionStored(emit),
    );
    on<ActionStarted<E>>(
      (final event, final emit) async =>
          await onActionStarted(event.data, emit),
    );
    on<ActionRestarted<E>>(
      (final event, final emit) async => await onActionRestarted(emit),
    );
  }

  Future<void> onActionStored(final Emitter<ActionState<S>> emit) async {
    final initialState = state;
    if (state is ActionInitial<S>) {
      emit(ActionInProgress<S>(data: null));

      emit(await doStored(null) ?? initialState);
    } else if (state is ActionFinal<S, E>) {
      final lastData = (state as ActionFinal<S, E>).data;
      emit(ActionInProgress<S>(data: lastData));

      emit(await doStored(lastData) ?? initialState);
    }
  }

  Future<void> onActionStarted(
    final E event,
    final Emitter<ActionState<S>> emit,
  ) async {
    if (state is ActionInitial<S>) {
      emit(ActionInProgress<S>(data: null));
      emit(await doAction(event, null));
    } else if (state is ActionFinal<S, E>) {
      final lastData = (state as ActionFinal<S, E>).data;
      emit(ActionInProgress<S>(data: lastData));

      emit(await doAction(event, lastData));
    }
  }

  Future<void> onActionRestarted(final Emitter<ActionState<S>> emit) async {
    if (state is ActionFinal<S, E>) {
      final lastEvent = (state as ActionFinal<S, E>).event;
      await onActionStarted(lastEvent, emit);
    }
  }

  Future<ActionFinal<S, E>?> doStored(final S? lastData) async {
    return null;
  }

  Future<ActionFinal<S, E>> doAction(final E event, final S? lastData);
}

abstract class ProducerActionBloc<S> extends FunctionActionBloc<void, S> {}

abstract class ConsumerActionBloc<E> extends FunctionActionBloc<E, void> {}

abstract class IdentityActionBloc<T> extends FunctionActionBloc<T, T> {}
