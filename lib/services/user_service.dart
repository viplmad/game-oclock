import 'package:game_oclock/models/models.dart' show AggregateSearch, idField;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class UserService {
  final UsersApi _api;

  UserService(ApiClient apiClient) : _api = UsersApi(apiClient);

  Future<PageResultDTO<UserDTO>> search(
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getUsers(search, q: quicksearch);
  }

  Future<int> count(AggregateSearch search, String? quicksearch) async {
    final response = await _api.aggregateUsersWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: idField.value,
          kind: AggregateMetricType.count,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<UserDTO> get(String id) async {
    return _api.getUser(id);
  }

  Future<String> create(NewUserDTO user, String password) async {
    return _api.createUser(password, user);
  }

  Future<void> update(String id, NewUserDTO user) async {
    return _api.updateUser(id, user);
  }

  Future<void> delete(String id) async {
    return _api.deleteUser(id);
  }

  Future<UserDTO> getCurrent() async {
    return _api.getCurrentUser();
  }

  Future<void> changePassword(
    String id,
    String currentPassword,
    String newPassword,
  ) async {
    return _api.changePassword(id, currentPassword, newPassword);
  }
}
