import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, PageResultDTO;
import 'package:rxdart/rxdart.dart';

EventTransformer<T> debounce<T>(final Duration duration) {
  return (final events, final mapper) =>
      events.debounceTime(duration).flatMap(mapper);
}

List<T> mergePageData<T>({
  required final ListSearch search,
  required final PageResultDTO<T> page,
  required final List<T>? lastData,
}) {
  if ((search.search.page ?? 0) == 0) {
    return List.unmodifiable(page.data);
  }
  return List.unmodifiable(
    lastData == null ? page.data : [...lastData, ...page.data],
  );
}

Future<int> mergeCount({
  required final ListSearch search,
  required final Future<int> Function() countGetter,
  required final int? lastTotal,
}) async {
  if ((search.search.page ?? 0) == 0 || lastTotal == null) {
    return countGetter();
  }
  return lastTotal;
}
