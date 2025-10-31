import 'package:game_oclock/models/models.dart' show User, UserChangePassword;
import 'package:game_oclock/services/services.dart' show UserService;

import '../action.dart'
    show
        ActionFinal,
        ActionSuccess,
        ConsumerActionBloc,
        FunctionActionBloc,
        IdentityActionBloc;

class UserGetBloc extends FunctionActionBloc<String, User> {
  UserGetBloc({required this.service});

  final UserService service;

  @override
  Future<ActionFinal<User, String>> doAction(
    final String event,
    final User? lastData,
  ) async {
    final data = await service.get(event);
    return ActionSuccess(data: data, event: event);
  }
}

class UserCreateBloc extends IdentityActionBloc<User> {
  UserCreateBloc({required this.service});

  final UserService service;

  @override
  Future<ActionFinal<User, User>> doAction(
    final User event,
    final User? lastData,
  ) async {
    final data = await service.create(event);
    return ActionSuccess(data: data, event: event);
  }
}

class UserUpdateBloc extends ConsumerActionBloc<User> {
  UserUpdateBloc({required this.service});

  final UserService service;

  @override
  Future<ActionFinal<void, User>> doAction(
    final User event,
    final void lastData,
  ) async {
    await service.update(event);
    return ActionSuccess.consumer(event);
  }
}

class UserChangePasswordBloc extends IdentityActionBloc<UserChangePassword> {
  UserChangePasswordBloc({required this.service});

  final UserService service;

  @override
  Future<ActionFinal<UserChangePassword, UserChangePassword>> doAction(
    final UserChangePassword event,
    final UserChangePassword? lastData,
  ) async {
    await service.changePassword(event.currentPassword, event.newPassword);
    return ActionSuccess(data: event, event: event);
  }
}
