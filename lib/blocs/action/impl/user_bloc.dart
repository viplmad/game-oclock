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
  Future<UserDTO> doAction(String event, UserDTO? lastData) =>
      service.get(event);
}

class UserCreateBloc extends FunctionActionBloc<NewUser, String> {
  UserCreateBloc({required this.service});

  final UserService service;

  @override
  Future<String> doAction(NewUser event, String? lastData) =>
      service.create(event as NewUserDTO, event.password);
}

class UserUpdateBloc extends ConsumerActionBloc<NewUserDTO> {
  UserUpdateBloc({required this.service, required this.id});

  final UserService service;
  final String id;

  @override
  Future<void> doAction(NewUserDTO event, void lastData) =>
      service.update(id, event);
}

class UserDeleteBloc extends ConsumerActionBloc<UserDTO> {
  UserDeleteBloc({required this.service});

  final UserService service;

  @override
  Future<void> doAction(UserDTO event, void lastData) =>
      service.delete(event.id);
}

class UserSelectBloc extends IdentityActionBloc<UserDTO?> {
  @override
  Future<UserDTO?> doAction(UserDTO? event, UserDTO? lastData) async => event;
}

class UserChangePasswordBloc extends ConsumerActionBloc<UserChangePassword> {
  UserChangePasswordBloc({required this.service, required this.id});

  final UserService service;
  final String id;

  @override
  Future<void> doAction(UserChangePassword event, void lastData) =>
      service.changePassword(id, event.currentPassword, event.newPassword);
}
