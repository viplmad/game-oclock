import 'package:game_oclock/blocs/list/list_state.dart';
import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, ListSearch, PageResultDTO, UserGame;

import 'list_bloc.dart' show ListLoadBloc;

class UserGameListBloc extends ListLoadBloc<UserGame> {
  @override
  Future<ListFinal<UserGame>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<UserGame>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = search.search.page ?? 0;
    final size = search.search.size ?? 50;
    final data = PageResultDTO(
      data: List.generate(size, (final index) {
        final finalIndex = (page * size) + index;
        return mockUserGame(title: 'title ($quicksearch) $finalIndex');
      }),
      page: page,
      size: size,
    );

    List<UserGame> finalData;
    if (page == 0) {
      finalData = data.data;
    } else {
      finalData = List.of(
        lastData == null ? data.data : [...lastData, ...data.data],
        growable: false,
      );
    }

    if (true) {
      return ListLoadSuccess<UserGame>(
        data: finalData,
        quicksearch: quicksearch,
        search: search,
      );
    } else {
      return ListLoadFailure<UserGame>(
        error: const ErrorDTO(code: 'code', message: 'message'),
        data: lastData ?? List.empty(growable: false),
        quicksearch: quicksearch,
        search: search,
      );
    }
  }
}
