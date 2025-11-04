import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show SearchDTO;

import 'list.dart'
    show
        ListEvent,
        ListFinal,
        ListInitial,
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

  Future<void> onListReloaded(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      final lastSearch = (state as ListFinal<S>).search;
      emit(
        ListLoadInProgress<S>(
          data: null,
          quicksearch: lastQuicksearch,
          search: lastSearch,
        ),
      );

      emit(await loadList(lastQuicksearch, lastSearch, null, null));
    }
  }

  Future<void> onListPageReloaded(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastTotal = (state as ListFinal<S>).total;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      final lastSearch = (state as ListFinal<S>).search;
      emit(
        ListLoadInProgress<S>(
          data: lastData,
          quicksearch: lastQuicksearch,
          search: lastSearch,
        ),
      );

      emit(await loadList(lastQuicksearch, lastSearch, lastData, lastTotal));
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
          quicksearch: quicksearch,
          search: search,
        ),
      );
      emit(await loadList(quicksearch, search, null, null));
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
          quicksearch: lastQuicksearch,
          search: lastSearch,
        ),
      );

      emit(
        await loadList(
          quicksearch,
          lastSearch.copyWith(page: 0),
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
      emit(await loadList(null, search, null, null));
    } else if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastTotal = (state as ListFinal<S>).total;
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
          lastTotal,
        ),
      );
    }
  }

  Future<void> onListPageIncremented(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastTotal = (state as ListFinal<S>).total;
      final lastQuicksearch = (state as ListFinal<S>).quicksearch;
      final lastSearch = (state as ListFinal<S>).search;

      final total = (state as ListFinal<S>).total;
      if (lastData.length >= total) {
        return; // No more data left to fetch
      }

      emit(
        ListLoadInProgress<S>(
          data: lastData,
          quicksearch: lastQuicksearch,
          search: lastSearch,
        ),
      );

      final nextPage = (lastSearch.page ?? 0) + 1;
      emit(
        await loadList(
          lastQuicksearch,
          lastSearch.copyWith(page: nextPage),
          lastData,
          lastTotal,
        ),
      );
    }
  }

  Future<ListFinal<S>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<S>? lastData,
    final int? lastTotal,
  );
}

abstract class LocalEditableListBloc<S> extends ListLoadBloc<S> {
  LocalEditableListBloc({required this.data});

  final List<S> data;

  @override
  Future<ListFinal<S>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<S>? lastData,
    final int? lastTotal,
  ) async {
    return ListLoadSuccess<S>(
      data: List.unmodifiable(data),
      quicksearch: quicksearch,
      search: search,
      total: data.length, // Everything has been "fetched"
    );
  }

  void addElement(final S newElement) {
    data.add(newElement);
    add(const ListReloaded());
  }

  void removeElement(final int index) {
    data.removeAt(index);
    add(const ListReloaded());
  }

  void replaceElement(final int oldIndex, final int newIndex) {
    final temp = data.elementAt(oldIndex);
    data[oldIndex] = data[newIndex];
    data[newIndex] = temp;
    add(const ListReloaded());
  }
}
