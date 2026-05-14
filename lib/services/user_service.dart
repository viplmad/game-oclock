import 'package:game_oclock/models/models.dart' show AggregateSearch;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class UserService {
  final UsersApi _api;

  UserService(final ApiClient apiClient) : _api = UsersApi(apiClient);

  Future<PageResultDTO<UserDTO>> search(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getUsers(search, q: quicksearch);
  }

  Future<int> count(
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateUsersWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<UserDTO> get(final String id) async {
    return _api.getUser(id);
  }

  Future<String> create(final NewUserDTO user, final String password) async {
    return _api.createUser(password, user);
  }

  Future<void> update(final String id, final NewUserDTO user) async {
    return _api.updateUser(id, user);
  }

  Future<void> delete(final String id) async {
    return _api.deleteUser(id);
  }

  Future<UserDTO> getCurrent() async {
    return _api.getCurrentUser();
  }

  Future<void> changePassword(
    final String id,
    final String currentPassword,
    final String newPassword,
  ) async {
    return _api.changePassword(id, currentPassword, newPassword);
  }
}
