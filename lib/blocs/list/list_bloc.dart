import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart'
    show FilterDTO, SearchDTO, SortDTO;

import 'list.dart'
    show
        ListEvent,
        ListFilterChanged,
        ListFinal,
        ListInitial,
        ListLoadInProgress,
        ListLoaded,
        ListPageIncremented,
        ListState;

abstract class ListLoadBloc<S> extends Bloc<ListEvent, ListState<S>> {
  ListLoadBloc() : super(ListInitial<S>()) {
    on<ListLoaded>(
      (final event, final emit) async => await onListLoaded(event.search, emit),
    );
    on<ListFilterChanged>(
      (final event, final emit) async =>
          await onListFilterChanged(event.filter, event.sort, emit),
    );
    on<ListPageIncremented>(
      (final event, final emit) async => await onListPageIncremented(emit),
    );
  }

  Future<void> onListLoaded(
    final SearchDTO search,
    final Emitter<ListState<S>> emit,
  ) async {
    if (state is ListInitial<S>) {
      emit(ListLoadInProgress<S>(data: null, search: null));
      emit(await loadList(search, null, null));
    } else if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastSearch = (state as ListFinal<S>).search;
      emit(ListLoadInProgress<S>(data: lastData, search: lastSearch));

      emit(await loadList(search, lastData, lastSearch));
    }
  }

  Future<void> onListFilterChanged(
    final List<FilterDTO>? filter,
    final List<SortDTO>? sort,
    final Emitter<ListState<S>> emit,
  ) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastSearch = (state as ListFinal<S>).search;
      emit(ListLoadInProgress<S>(data: lastData, search: lastSearch));

      emit(
        await loadList(
          lastSearch.copyWith(filter: filter, sort: sort, page: 0),
          lastData,
          lastSearch,
        ),
      );
    }
  }

  Future<void> onListPageIncremented(final Emitter<ListState<S>> emit) async {
    if (state is ListFinal<S>) {
      final lastData = (state as ListFinal<S>).data;
      final lastSearch = (state as ListFinal<S>).search;
      emit(ListLoadInProgress<S>(data: lastData, search: lastSearch));

      final nextPage = (lastSearch.page ?? 0) + 1;
      emit(
        await loadList(
          lastSearch.copyWith(page: nextPage),
          lastData,
          lastSearch,
        ),
      );
    }
  }

  Future<ListFinal<S>> loadList(
    final SearchDTO search,
    final List<S>? lastData,
    final SearchDTO? lastSearch,
  );
}
