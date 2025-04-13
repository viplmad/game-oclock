import 'dart:math';

import 'package:game_oclock/blocs/list/list_state.dart';
import 'package:game_oclock/models/models.dart';

import '../action/action.dart' show Counter;
import 'list_bloc.dart' show ListLoadBloc;

class CounterListBloc extends ListLoadBloc<Counter> {
  @override
  Future<ListFinal<Counter>> loadList(
    final SearchDTO search,
    final List<Counter>? lastData,
    final SearchDTO? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = search.page ?? 0;
    final size = search.size ?? 50;
    final data = PageResultDTO(
      data: List.generate(size, (final index) {
        final finalIndex = (page * size) + index;
        return Counter(name: 'name$finalIndex', data: finalIndex);
      }),
      page: page,
      size: size,
    );

    if (Random.secure().nextBool()) {
      return ListLoadSuccess<Counter>(
        data: List.of(
          lastData == null ? data.data : [...lastData, ...data.data],
          growable: false,
        ),
        search: search,
      );
    } else {
      return ListLoadFailure<Counter>(
        error: ErrorDTO(code: 'code', message: 'message'),
        data: lastData ?? List.empty(growable: false),
        search: search,
      );
    }
  }
}
