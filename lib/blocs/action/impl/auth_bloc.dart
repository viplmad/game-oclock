import 'package:game_oclock/models/models.dart'
    show Login, SavedLoginResponse, User;
import 'package:game_oclock/services/services.dart'
    show AuthService, LoginService, UserService;

import '../action.dart' show ConsumerActionBloc, ProducerActionBloc;

class CurrentUserGetBloc extends ProducerActionBloc<User> {
  CurrentUserGetBloc({required this.service});

  final UserService service;

  @override
  Future<User> doAction(final void event, final User? lastData) =>
      service.getCurrent();
}

class SavedLoginResponseGetBloc
    extends ProducerActionBloc<SavedLoginResponse?> {
  SavedLoginResponseGetBloc({required this.service});

  final AuthService service;

  @override
  Future<SavedLoginResponse?> doAction(
    final void event,
    final SavedLoginResponse? lastData,
  ) => service.getCurrent();
}

class LoginSaveBloc extends ConsumerActionBloc<Login> {
  LoginSaveBloc({required this.service, required this.authService});

  final LoginService service;
  final AuthService authService;

  @override
  Future<void> doAction(final Login event, final void lastData) async {
    final loginResponse = await service.login(
      event.host,
      event.username,
      event.password,
    );
    return authService.saveCurrent(
      SavedLoginResponse(
        host: event.host,
        username: event.username,
        tokenResponse: loginResponse,
      ),
    );
  }
}
