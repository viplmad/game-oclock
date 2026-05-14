import 'package:game_oclock/models/models.dart' show AggregateSearch;
import 'package:game_oclock/services/services.dart' show UserService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class UserListBloc extends ListLoadBloc<UserDTO> {
  UserListBloc({required this.service});

  final UserService service;

  @override
  Future<PageResultDTO<UserDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.count(AggregateSearch(filter: search.filter), quicksearch);
}
