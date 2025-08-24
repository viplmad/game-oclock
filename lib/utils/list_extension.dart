import 'dart:collection';

extension ListExtension<T> on Iterable<T> {
  Map<K, List<T>> orderedGroupBy<K>(final K Function(T item) keyGetter) {
    final map = SplayTreeMap<K, List<T>>();
    for (final item in this) {
      (map[keyGetter(item)] ??= []).add(item);
    }
    return map;
  }
}
