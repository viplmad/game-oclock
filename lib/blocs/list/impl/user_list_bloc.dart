import 'package:game_oclock/models/models.dart'
    show PageResultDTO, SearchDTO, User;
import 'package:game_oclock/services/services.dart' show UserService;

import '../list.dart' show ListLoadBloc;

class UserListBloc extends ListLoadBloc<User> {
  UserListBloc({required this.service});

  final UserService service;

  @override
  Future<PageResultDTO<User>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.count(search, quicksearch);
}
