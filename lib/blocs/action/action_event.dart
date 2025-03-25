import 'package:equatable/equatable.dart';

sealed class ActionEvent<T> extends Equatable {}

final class ActionStarted<T> extends ActionEvent<T> {
  final T data;

  ActionStarted({required this.data});
  // ignore: void_checks
  static ActionStarted<void> empty() => ActionStarted<void>(data: '');

  @override
  List<Object?> get props => [data];
}
