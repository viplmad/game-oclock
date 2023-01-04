import 'package:game_collection_client/api.dart'
    show ApiClient, NewUserDTO, PasswordChangeDTO, UserDTO, UserSearchResult, UsersApi;

import 'item_service.dart';

class UserService implements ItemService<UserDTO, NewUserDTO> {
  UserService(ApiClient apiClient) {
    _api = UsersApi(apiClient);
  }

  late final UsersApi _api; // TODO make private

  @override
  bool sameId(UserDTO one, UserDTO other) {
    return one.id == other.id;
  }

  //#region CREATE
  @override
  Future<UserDTO> create(NewUserDTO newItem) {
    return _api.postUser(newItem) as Future<UserDTO>;
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<UserDTO> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  Future<UserDTO> getCurrentUser() {
    return _api.getCurrentUser() as Future<UserDTO>;
  }

  @override
  Future<UserSearchResult> getAll<A>(
    int viewIndex, {
    int? page,
    int? size,
    A? viewArgs,
  }) {
    // TODO: implement searchAll
    throw UnimplementedError();
  }

  @override
  Future<UserSearchResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    // TODO: implement searchAll
    throw UnimplementedError();
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<UserDTO> update(int id, NewUserDTO updatedItem) {
    // TODO: implement update
    throw UnimplementedError();
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
    // TODO: implement delete
    throw UnimplementedError();
  }
  //#endregion DELETE
}
