import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show SearchDTO, User;
import 'package:game_oclock/services/services.dart' show UserService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class UserListBloc extends ListLoadBloc<User> {
  UserListBloc({required this.service});

  final UserService service;

  @override
  Future<ListFinal<User>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<User>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.search(search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.count(search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<User>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
