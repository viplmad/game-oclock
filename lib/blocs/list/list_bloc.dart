import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, GameOClockException, errorCodeUnknown;
import 'package:game_oclock_client/api.dart';

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

abstract class ListLoadBloc<S extends Object>
    extends Bloc<ListEvent, ListState<S>> {
  ListLoadBloc() : super(ListInitial<S>()) {
    on<ListReloaded>((event, emit) async => await onListReloaded(emit));
    on<ListPageReloaded>((event, emit) async => await onListPageReloaded(emit));
    on<ListSearchChanged>(
      (event, emit) async => await onListSearchChanged(event.search, emit),
    );
    on<ListQuicksearchChanged>(
      (event, emit) async =>
          await onListQuicksearchChanged(event.quicksearch, emit),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<ListPageIncremented>(
      (event, emit) async => await onListPageIncremented(emit),
    );
  }

  Future<void> onListReloaded(Emitter<ListState<S>> emit) async {
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

  Future<void> onListPageReloaded(Emitter<ListState<S>> emit) async {
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
    String? quicksearch,
    Emitter<ListState<S>> emit,
  ) async {
    if (state is ListInitial<S>) {
      final search = ListSearchDTO();
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
    ListSearchDTO search,
    Emitter<ListState<S>> emit,
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

  Future<void> onListPageIncremented(Emitter<ListState<S>> emit) async {
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
    ListSearchDTO search,
    String? quicksearch,
    List<S>? lastData,
    int? lastTotal,
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
    } catch (e, s) {
      return ListLoadFailure<S>(
        error: ErrorDTO(code: errorCodeUnknown, message: '$e: $s'),
        data: lastData ?? [],
        total: lastTotal ?? 0,
        search: search,
        quicksearch: quicksearch,
      );
    }
  }

  Future<PageResultDTO<S>> doLoad(ListSearchDTO search, String? quicksearch);

  Future<int?> doCount(ListSearchDTO search, String? quicksearch);
}
