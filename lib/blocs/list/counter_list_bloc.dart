import 'dart:math';

import 'package:game_oclock/blocs/list/list_state.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, ListSearch, PageResultDTO;

import '../action/action.dart' show Counter;
import 'list_bloc.dart' show ListLoadBloc;

class CounterListBloc extends ListLoadBloc<Counter> {
  @override
  Future<ListFinal<Counter>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<Counter>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = search.search.page ?? 0;
    final size = search.search.size ?? 50;
    final data = PageResultDTO(
      data: List.generate(size, (final index) {
        final finalIndex = (page * size) + index;
        return Counter(
          name: 'name ($quicksearch) $finalIndex',
          data: finalIndex,
        );
      }),
      page: page,
      size: size,
    );

    List<Counter> finalData;
    if (page == 0) {
      finalData = data.data;
    } else {
      finalData = List.of(
        lastData == null ? data.data : [...lastData, ...data.data],
        growable: false,
      );
    }

    if (Random.secure().nextBool()) {
      return ListLoadSuccess<Counter>(
        data: finalData,
        quicksearch: quicksearch,
        search: search,
      );
    } else {
      return ListLoadFailure<Counter>(
        error: ErrorDTO(code: 'code', message: 'message'),
        data: lastData ?? List.empty(growable: false),
        quicksearch: quicksearch,
        search: search,
      );
    }
  }
}
