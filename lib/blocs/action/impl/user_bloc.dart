import 'package:game_oclock/models/models.dart'
    show NewUser, UserChangePassword;
import 'package:game_oclock/services/services.dart' show UserService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class UserGetBloc extends FunctionActionBloc<String, UserDTO> {
  UserGetBloc({required this.service});

  final UserService service;

  @override
  Future<UserDTO> doAction(final String event, final UserDTO? lastData) =>
      service.get(event);
}

class UserCreateBloc extends FunctionActionBloc<NewUser, String> {
  UserCreateBloc({required this.service});

  final UserService service;

  @override
  Future<String> doAction(final NewUser event, final String? lastData) =>
      service.create(event as NewUserDTO, event.password);
}

class UserUpdateBloc extends ConsumerActionBloc<NewUserDTO> {
  UserUpdateBloc({required this.service, required this.id});

  final UserService service;
  final String id;

  @override
  Future<void> doAction(final NewUserDTO event, final void lastData) =>
      service.update(id, event);
}

class UserDeleteBloc extends ConsumerActionBloc<UserDTO> {
  UserDeleteBloc({required this.service});

  final UserService service;

  @override
  Future<void> doAction(final UserDTO event, final void lastData) =>
      service.delete(event.id);
}

class UserSelectBloc extends IdentityActionBloc<UserDTO?> {
  @override
  Future<UserDTO?> doAction(
    final UserDTO? event,
    final UserDTO? lastData,
  ) async => event;
}

class UserChangePasswordBloc extends ConsumerActionBloc<UserChangePassword> {
  UserChangePasswordBloc({required this.service, required this.id});

  final UserService service;
  final String id;

  @override
  Future<void> doAction(final UserChangePassword event, final void lastData) =>
      service.changePassword(id, event.currentPassword, event.newPassword);
}
