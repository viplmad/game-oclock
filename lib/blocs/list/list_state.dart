import 'package:game_oclock/models/models.dart'
    show ErrorDTO, PageResultDTO, SearchDTO;

sealed class ListState<T> {}

final class ListInitial<T> extends ListState<T> {}

final class ListLoadInProgress<T> extends ListState<T> {
  final PageResultDTO<T>? data;
  final SearchDTO? search;

  ListLoadInProgress({required this.data, required this.search});
}

sealed class ListFinal<T> extends ListState<T> {
  final PageResultDTO<T> data;
  final SearchDTO search;

  ListFinal({required this.data, required this.search});
}

final class ListLoadSuccess<T> extends ListFinal<T> {
  ListLoadSuccess({required super.data, required super.search});
}

final class ListLoadFailure<T> extends ListFinal<T> {
  final ErrorDTO error;

  ListLoadFailure({
    required this.error,
    required super.data,
    required super.search,
  });
}
