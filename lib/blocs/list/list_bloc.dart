import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart'
    show
        ErrorDTO,
        GameOClockException,
        PageResultDTO,
        SearchDTO,
        errorCodeUnknown;

import 'list.dart'
    show
        ListEvent,
        ListFinal,
        ListInitial,
        ListLoadFailure,
        ListLoadInProgress,
        ListLoadSuccess,
        ListPageIncremented,
        ListPageReloaded,
        ListQuicksearchChanged,
        ListReloaded,
        ListSearchChanged,
        ListState;

abstract class ListLoadBloc<S> extends Bloc<ListEvent, ListState<S>> {
  ListLoadBloc() : super(ListInitial<S>()) {
    on<ListReloaded>(
      (final event, final emit) async => await onListReloaded(emit),
    );
    on<ListPageReloaded>(
      (final event, final emit) async => await onListPageReloaded(emit),
    );
    on<ListSearchChanged>(
      (final event, final emit) async =>
          await onListSearchChanged(event.search, emit),
    );
    on<ListQuicksearchChanged>(
      (final event, final emit) async =>
          await onListQuicksearchChanged(event.quicksearch, emit),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<ListPageIncremented>(
      (final event, final emit) async => await onListPageIncremented(emit),
    );
  }

  Future<void> onListReloaded(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastSearch = (state as ListFinal<S>).search;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      emit(
        ListLoadInProgress<S>(
          data: null,
          search: lastSearch,
          quicksearch: lastQuicksearch,
        ),
      );

      emit(await _tryLoadList(lastSearch, lastQuicksearch, null, null));
    }
  }

  Future<void> onListPageReloaded(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastTotal = (state as ListFinal<S>).total;
      final lastSearch = (state as ListFinal<S>).search;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      emit(
        ListLoadInProgress<S>(
          data: lastData,
          search: lastSearch,
          quicksearch: lastQuicksearch,
        ),
      );

      emit(
        await _tryLoadList(lastSearch, lastQuicksearch, lastData, lastTotal),
      );
    }
  }

  Future<void> onListQuicksearchChanged(
    final String? quicksearch,
    final Emitter<ListState<S>> emit,
  ) async {
    if (state is ListInitial<S>) {
      final search = SearchDTO();
      emit(
        ListLoadInProgress<S>(
          data: null,
          search: search,
          quicksearch: quicksearch,
        ),
      );
      emit(await _tryLoadList(search, quicksearch, null, null));
    } else if (state is ListFinal<S>) {
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      if (lastQuicksearch == quicksearch) {
        return;
      }

      final lastData = (state as ListFinal<S>).data;
      final lastTotal = (state as ListFinal<S>).total;
      final lastSearch = (state as ListFinal<S>).search;
      emit(
        ListLoadInProgress<S>(
          data: null,
          search: lastSearch,
          quicksearch: lastQuicksearch,
        ),
      );

      emit(
        await _tryLoadList(
          lastSearch.copyWith(page: 0),
          quicksearch,
          lastData,
          lastTotal,
        ),
      );
    }
  }

  Future<void> onListSearchChanged(
    final SearchDTO search,
    final Emitter<ListState<S>> emit,
  ) async {
    if (state is ListInitial<S>) {
      emit(
        ListLoadInProgress<S>(data: null, quicksearch: null, search: search),
      );
      emit(await _tryLoadList(search, null, null, null));
    } else if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastTotal = (state as ListFinal<S>).total;
      final lastSearch = (state as ListFinal<S>).search;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      emit(
        ListLoadInProgress<S>(
          data: null,
          search: lastSearch,
          quicksearch: lastQuicksearch,
        ),
      );

      emit(
        await _tryLoadList(
          search.copyWith(page: 0),
          lastQuicksearch,
          lastData,
          lastTotal,
        ),
      );
    }
  }

  Future<void> onListPageIncremented(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastTotal = (state as ListFinal<S>).total;
      final lastSearch = (state as ListFinal<S>).search;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;

      final total = (state as ListFinal<S>).total;
      if (lastData.length >= total) {
        return; // No more data left to fetch
      }

      emit(
        ListLoadInProgress<S>(
          data: lastData,
          search: lastSearch,
          quicksearch: lastQuicksearch,
        ),
      );

      final nextPage = (lastSearch.page ?? 0) + 1;
      emit(
        await _tryLoadList(
          lastSearch.copyWith(page: nextPage),
          lastQuicksearch,
          lastData,
          lastTotal,
        ),
      );
    }
  }

  Future<ListFinal<S>> _tryLoadList(
    final SearchDTO search,
    final String? quicksearch,
    final List<S>? lastData,
    final int? lastTotal,
  ) async {
    try {
      final data = mergePageData(
        search: search,
        page: await doLoad(search, quicksearch),
        lastData: lastData,
      );
      final count = await mergeCount(
        search: search,
        countGetter: () async =>
            await doCount(search, quicksearch) ?? data.length,
        lastTotal: lastTotal,
      );
      return ListLoadSuccess<S>(
        data: data,
        total: count,
        search: search,
        quicksearch: quicksearch,
      );
    } on GameOClockException catch (e) {
      return ListLoadFailure<S>(
        error: ErrorDTO(code: e.code, message: e.message),
        data: lastData ?? [],
        total: lastTotal ?? 0,
        search: search,
        quicksearch: quicksearch,
      );
    } catch (e) {
      return ListLoadFailure<S>(
        error: ErrorDTO(code: errorCodeUnknown, message: e.toString()),
        data: lastData ?? [],
        total: lastTotal ?? 0,
        search: search,
        quicksearch: quicksearch,
      );
    }
  }

  Future<PageResultDTO<S>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  );

  Future<int?> doCount(final SearchDTO search, final String? quicksearch);
}
