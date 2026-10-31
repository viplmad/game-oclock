import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock_client/api.dart';
import 'package:rxdart/rxdart.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

List<T> mergePageData<T extends Object>({
  required ListSearchDTO search,
  required PageResultDTO<T> page,
  required List<T>? lastData,
}) {
  if ((search.page ?? 0) == 0) {
    return List.unmodifiable(page.data);
  }
  return List.unmodifiable(
    lastData == null ? page.data : [...lastData, ...page.data],
  );
}

Future<int> mergeCount({
  required ListSearchDTO search,
  required Future<int> Function() countGetter,
  required int? lastTotal,
}) async {
  if ((search.page ?? 0) == 0 || lastTotal == null) {
    return countGetter();
  }
  return lastTotal;
}
