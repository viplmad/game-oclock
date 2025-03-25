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

sealed class ActionFinal<T> extends ActionState<T> {
  final T data;

  const ActionFinal({required this.data});

  @override
  List<Object?> get props => [data];
}

final class ActionSuccess<T> extends ActionFinal<T> {
  const ActionSuccess({required super.data});
  // ignore: void_checks
  static ActionSuccess<void> empty() => const ActionSuccess<void>(data: '');
}

final class ActionFailure<T> extends ActionFinal<T> {
  final ErrorDTO error;

  const ActionFailure({required this.error, required super.data});
  static ActionFailure<void> empty(final ErrorDTO error) =>
  // ignore: void_checks
  ActionFailure<void>(data: '', error: error);

  @override
  List<Object?> get props => [error, ...super.props];
}
