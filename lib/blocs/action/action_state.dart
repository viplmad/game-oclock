import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart' show ErrorDTO;

sealed class ActionState<S> extends Equatable {
  const ActionState();
}

final class ActionInitial<S> extends ActionState<S> {
  const ActionInitial();

  @override
  List<Object?> get props => [];
}

final class ActionInProgress<S> extends ActionState<S> {
  final S? data;

  const ActionInProgress({required this.data});

  @override
  List<Object?> get props => [data];
}

sealed class ActionFinal<S, E> extends ActionState<S> {
  final E event;

  const ActionFinal({required this.event});
}

final class ActionSuccess<S, E> extends ActionFinal<S, E> {
  final S data;

  const ActionSuccess({required this.data, required super.event});

  @override
  List<Object?> get props => [data];
}

final class ActionFailure<S, E> extends ActionFinal<S, E> {
  final ErrorDTO error;

  const ActionFailure({required this.error, required super.event});

  @override
  List<Object?> get props => [error];
}
