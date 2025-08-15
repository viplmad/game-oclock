import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;
import 'package:rxdart/rxdart.dart';

import 'list.dart'
    show
        ListEvent,
        ListFinal,
        ListInitial,
        ListLoadInProgress,
        ListLoaded,
        ListPageIncremented,
        ListQuicksearchChanged,
        ListReloaded,
        ListSearchChanged,
        ListState;

// TODO move
EventTransformer<T> debounce<T>(final Duration duration) {
  return (final events, final mapper) =>
      events.debounceTime(duration).flatMap(mapper);
}

abstract class ListLoadBloc<S> extends Bloc<ListEvent, ListState<S>> {
  ListLoadBloc() : super(ListInitial<S>()) {
    on<ListLoaded>(
      (final event, final emit) async => await onListLoaded(event.search, emit),
    );
    on<ListReloaded>(
      (final event, final emit) async => await onListReloaded(emit),
    );
    on<ListQuicksearchChanged>(
      (final event, final emit) async =>
          await onListQuicksearchChanged(event.quicksearch, emit),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<ListSearchChanged>(
      (final event, final emit) async =>
          await onListSearchChanged(event.search, emit),
    );
    on<ListPageIncremented>(
      (final event, final emit) async => await onListPageIncremented(emit),
    );
  }

  Future<void> onListLoaded(
    final ListSearch search,
    final Emitter<ListState<S>> emit,
  ) async {
    if (state is ListInitial<S>) {
      emit(ListLoadInProgress<S>(data: null, quicksearch: null, search: null));
      emit(await loadList(null, search, null, null, null));
    } else if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      final lastSearch = (state as ListFinal<S>).search;
      emit(
        ListLoadInProgress<S>(
          data: lastData,
          quicksearch: lastQuicksearch,
          search: lastSearch,
        ),
      );

      emit(
        await loadList(
          lastQuicksearch,
          search,
          lastData,
          lastQuicksearch,
          lastSearch,
        ),
      );
    }
  }

  Future<void> onListReloaded(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastSearch = (state as ListFinal<S>).search;
      // TODO Missing quicksearch
      onListLoaded(lastSearch, emit);
    }
  }

  Future<void> onListQuicksearchChanged(
    final String? quicksearch,
    final Emitter<ListState<S>> emit,
  ) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      final lastSearch = (state as ListFinal<S>).search;
      emit(
        ListLoadInProgress<S>(
          data: null,
          quicksearch: lastQuicksearch,
          search: lastSearch,
        ),
      );

      emit(
        await loadList(
          quicksearch,
          lastSearch.copyWith(page: 0),
          lastData,
          lastQuicksearch,
          lastSearch,
        ),
      );
    }
  }

  Future<void> onListSearchChanged(
    final ListSearch search,
    final Emitter<ListState<S>> emit,
  ) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      final lastSearch = (state as ListFinal<S>).search;
      emit(
        ListLoadInProgress<S>(
          data: null,
          quicksearch: lastQuicksearch,
          search: lastSearch,
        ),
      );

      emit(
        await loadList(
          lastQuicksearch,
          search.copyWith(page: 0),
          lastData,
          lastQuicksearch,
          lastSearch,
        ),
      );
    }
  }

  Future<void> onListPageIncremented(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      final lastSearch = (state as ListFinal<S>).search;
      emit(
        ListLoadInProgress<S>(
          data: lastData,
          quicksearch: lastQuicksearch,
          search: lastSearch,
        ),
      );

      final nextPage = (lastSearch.search.page ?? 0) + 1;
      emit(
        await loadList(
          lastQuicksearch,
          lastSearch.copyWith(page: nextPage),
          lastData,
          lastQuicksearch,
          lastSearch,
        ),
      );
    }
  }

  Future<ListFinal<S>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<S>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  );
}
