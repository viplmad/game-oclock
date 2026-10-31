extension ListExtension<T> on Iterable<T> {
  Map<K, List<T>> groupBy<K>(K Function(T item) keyGetter) {
    final map = <K, List<T>>{};
    for (final item in this) {
      (map[keyGetter(item)] ??= []).add(item);
    }
    return map;
  }
}
