sealed class ActionEvent<T> {}

final class ActionStarted<T> extends ActionEvent<T> {
  final T data;

  ActionStarted({required this.data});
  // ignore: void_checks
  static ActionStarted<void> empty() => ActionStarted<void>(data: '');
}
