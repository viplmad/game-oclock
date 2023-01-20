import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        NewUserDTO,
        OrderType,
        PasswordChangeDTO,
        SearchDTO,
        SortDTO,
        UserDTO,
        UserPageResult,
        UsersApi;

import 'package:backend/model/model.dart' show UserView;

import 'item_service.dart';

class UserService implements ItemService<UserDTO, NewUserDTO> {
  UserService(ApiClient apiClient) {
    _api = UsersApi(apiClient);
  }

  late final UsersApi _api;

  //#region CREATE
  @override
  Future<UserDTO> create(NewUserDTO newItem) {
    return _api.postUser(newItem);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<UserDTO> get(int id) {
    return _api.getUser(id);
  }

  Future<UserDTO> getCurrentUser() {
    return _api.getCurrentUser();
  }

  @override
  Future<UserPageResult> getAll<A>(
    int viewIndex, {
    int? page,
    int? size,
    A? viewArgs,
  }) {
    final UserView view = UserView.values[viewIndex];
    final List<SortDTO> sorts = <SortDTO>[];
    switch (view) {
      case UserView.main:
        sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));
        sorts.add(SortDTO(field: 'username', order: OrderType.asc));
        break;
      case UserView.lastAdded:
        sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));
        break;
      case UserView.lastUpdated:
        sorts.add(SortDTO(field: 'updated_datetime', order: OrderType.desc));
        break;
    }
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
  Future<UserDTO> update(int id, NewUserDTO updatedItem) {
    return _api.putUser(id, updatedItem);
  }

  Future<void> changePassword(String currentPassword, String newPassword) {
    return _api.changePassword(
      PasswordChangeDTO(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }
  //#region UPDATE

  //#region DELETE
  @override
  Future<void> delete(int id) {
    return _api.deleteUser(id);
  }
  //#endregion DELETE
}
