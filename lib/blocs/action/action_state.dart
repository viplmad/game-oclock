import 'package:game_oclock/models/models.dart' show ErrorDTO;

sealed class ActionState<T> {}

final class ActionInitial<T> extends ActionState<T> {}

final class ActionInProgress<T> extends ActionState<T> {
  final T? data;

  ActionInProgress({required this.data});
  // ignore: void_checks
  static ActionInProgress<void> empty() => ActionInProgress<void>(data: '');
}

sealed class ActionFinal<T> extends ActionState<T> {
  final T data;

  ActionFinal({required this.data});
}

final class ActionSuccess<T> extends ActionFinal<T> {
  ActionSuccess({required super.data});
  // ignore: void_checks
  static ActionSuccess<void> empty() => ActionSuccess<void>(data: '');
}

final class ActionFailure<T> extends ActionFinal<T> {
  final ErrorDTO error;

  ActionFailure({required this.error, required super.data});
  static ActionFailure<void> empty(final ErrorDTO error) =>
  // ignore: void_checks
  ActionFailure<void>(data: '', error: error);
}
