import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        NewUserDTO,
        OrderType,
        SearchDTO,
        SortDTO,
        UserDTO,
        UserPageResult,
        UsersApi;

import 'item_service.dart';

class UserService implements ItemService<UserDTO, NewUserDTO> {
  UserService(ApiClient apiClient) {
    _api = UsersApi(apiClient);
  }

  late final UsersApi _api;

  //#region CREATE
  @override
  Future<UserDTO> create(NewUserDTO newItem) {
    return _api.postUser('password', newItem); // TODO
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<UserDTO> get(String id) {
    return _api.getUser(id);
  }

  Future<UserDTO> getCurrentUser() {
    return _api.getCurrentUser();
  }

  @override
  Future<UserPageResult> getAll({
    int? page,
    int? size,
  }) {
    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));
    sorts.add(SortDTO(field: 'username', order: OrderType.asc));

    return _api.getUsers(
      SearchDTO(sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<UserPageResult> getLastAdded({
    int? page,
    int? size,
  }) {
    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));

    return _api.getUsers(
      SearchDTO(sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<UserPageResult> getLastUpdated({
    int? page,
    int? size,
  }) {
    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'updated_datetime', order: OrderType.desc));

    return _api.getUsers(
      SearchDTO(sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<UserPageResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return _api.getUsers(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    );
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<void> update(String id, NewUserDTO updatedItem) {
    return _api.putUser(id, updatedItem);
  }

  Future<void> changePassword(String currentPassword, String newPassword) {
    return _api.changePassword(currentPassword, newPassword);
  }
  //#region UPDATE

  //#region DELETE
  @override
  Future<void> delete(String id) {
    return _api.deleteUser(id);
  }
  //#endregion DELETE
}
