import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, GameOClockException, errorCodeUnknown;

import 'action.dart'
    show
        ActionEvent,
        ActionFailure,
        ActionFinal,
        ActionInProgress,
        ActionInitial,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess;

abstract class FunctionActionBloc<E, S>
    extends Bloc<ActionEvent<E>, ActionState<S>> {
  FunctionActionBloc() : super(ActionInitial<S>()) {
    on<ActionStarted<E>>(
      (final event, final emit) async =>
          await onActionStarted(event.data, emit),
    );
    on<ActionRestarted<E>>(
      (final event, final emit) async => await onActionRestarted(emit),
    );
  }

  Future<void> onActionStarted(
    final E event,
    final Emitter<ActionState<S>> emit,
  ) async {
    if (state is ActionInitial<S>) {
      emit(ActionInProgress<S>(data: null));
      emit(await _tryDoAction(event, null));
    } else if (state is ActionFinal<S, E>) {
      final S? lastData = (state is ActionSuccess<S, E>)
          ? (state as ActionSuccess<S, E>).data
          : null;
      emit(ActionInProgress<S>(data: lastData));

      emit(await _tryDoAction(event, lastData));
    }
  }

  Future<void> onActionRestarted(final Emitter<ActionState<S>> emit) async {
    if (state is ActionFinal<S, E>) {
      final lastEvent = (state as ActionFinal<S, E>).event;
      await onActionStarted(lastEvent, emit);
    }
  }

  Future<ActionFinal<S, E>> _tryDoAction(
    final E event,
    final S? lastData,
  ) async {
    try {
      return ActionSuccess<S, E>(
        data: await doAction(event, lastData),
        event: event,
      );
    } on GameOClockException catch (e) {
      return ActionFailure<S, E>(
        error: ErrorDTO(code: e.code, message: e.message),
        event: event,
      );
    } catch (e) {
      return ActionFailure<S, E>(
        error: ErrorDTO(code: errorCodeUnknown, message: e.toString()),
        event: event,
      );
    }
  }

  Future<S> doAction(final E event, final S? lastData);
}

abstract class ProducerActionBloc<S> extends FunctionActionBloc<void, S> {}

abstract class ConsumerActionBloc<E> extends FunctionActionBloc<E, void> {}

abstract class IdentityActionBloc<T> extends FunctionActionBloc<T, T> {}
