import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart' show ErrorDTO;

sealed class ActionState<T> extends Equatable {
  const ActionState();
}

final class ActionInitial<T> extends ActionState<T> {
  const ActionInitial();

  @override
  List<Object?> get props => [];
}

final class ActionInProgress<T> extends ActionState<T> {
  final T? data;

  const ActionInProgress({required this.data});
  static ActionInProgress<void> empty() =>
      // ignore: void_checks
      const ActionInProgress<void>(data: '');

  @override
  List<Object?> get props => [data];
}

sealed class ActionFinal<T, K> extends ActionState<T> {
  final T data;
  final K event;

  const ActionFinal({required this.data, required this.event});

  @override
  List<Object?> get props => [data];
}

final class ActionSuccess<T, K> extends ActionFinal<T, K> {
  const ActionSuccess({required super.data, required super.event});
  static ActionSuccess<void, S> empty<S>(final S event) =>
      // ignore: void_checks
      ActionSuccess<void, S>(data: '', event: event);
}

final class ActionFailure<T, K> extends ActionFinal<T, K> {
  final ErrorDTO error;

  const ActionFailure({
    required this.error,
    required super.data,
    required super.event,
  });
  static ActionFailure<void, S> empty<S>(final ErrorDTO error, final S event) =>
      // ignore: void_checks
      ActionFailure<void, S>(data: '', event: event, error: error);

  @override
  List<Object?> get props => [error, ...super.props];
}
