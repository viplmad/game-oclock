import 'package:game_oclock/models/models.dart' show User, UserChangePassword;
import 'package:game_oclock/services/services.dart' show UserService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class UserGetBloc extends FunctionActionBloc<String, User> {
  UserGetBloc({required this.service});

  final UserService service;

  @override
  Future<User> doAction(final String event, final User? lastData) =>
      service.get(event);
}

class UserCreateBloc extends IdentityActionBloc<User> {
  UserCreateBloc({required this.service});

  final UserService service;

  @override
  Future<User> doAction(final User event, final User? lastData) =>
      service.create(event);
}

class UserUpdateBloc extends ConsumerActionBloc<User> {
  UserUpdateBloc({required this.service});

  final UserService service;

  @override
  Future<void> doAction(final User event, final void lastData) =>
      service.update(event);
}

class UserChangePasswordBloc extends IdentityActionBloc<UserChangePassword> {
  UserChangePasswordBloc({required this.service});

  final UserService service;

  @override
  Future<UserChangePassword> doAction(
    final UserChangePassword event,
    final UserChangePassword? lastData,
  ) => service
      .changePassword(event.currentPassword, event.newPassword)
      .then((_) => event);
}
