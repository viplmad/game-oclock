import 'package:equatable/equatable.dart';

sealed class ActionEvent<T> extends Equatable {
  const ActionEvent();
}

final class ActionStarted<T> extends ActionEvent<T> {
  final T data;

  const ActionStarted({required this.data});
  // ignore: void_checks
  static ActionStarted<void> empty() => const ActionStarted<void>(data: '');

  @override
  List<Object?> get props => [data];
}

final class ActionRestarted<T> extends ActionEvent<T> {
  const ActionRestarted();

  @override
  List<Object?> get props => [];
}
