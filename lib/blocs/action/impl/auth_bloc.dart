import 'package:game_oclock/models/models.dart'
    show Login, SavedLoginResponse, User;
import 'package:game_oclock/services/services.dart'
    show AuthService, LoginService, UserService;

import '../action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, ProducerActionBloc;

class CurrentUserGetBloc extends ProducerActionBloc<User> {
  CurrentUserGetBloc({required this.service});

  final UserService service;

  @override
  Future<ActionFinal<User, void>> doAction(
    final void event,
    final User? lastData,
  ) async {
    final data = await service.getCurrent();
    return ActionSuccess.producer(data);
  }
}

class SavedLoginResponseGetBloc extends ProducerActionBloc<SavedLoginResponse> {
  SavedLoginResponseGetBloc({required this.service});

  final AuthService service;

  @override
  Future<ActionFinal<SavedLoginResponse, void>> doAction(
    final void event,
    final SavedLoginResponse? lastData,
  ) async {
    final data = await service.getSavedLoginResponse();
    return ActionSuccess.producer(data);
  }
}

class LoginSaveBloc extends ConsumerActionBloc<Login> {
  LoginSaveBloc({required this.service, required this.authService});

  final LoginService service;
  final AuthService authService;

  @override
  Future<ActionFinal<void, Login>> doAction(
    final Login event,
    final void lastData,
  ) async {
    final loginResponse = await service.login(
      event.host,
      event.username,
      event.password,
    );
    authService.saveLoginResponse(
      SavedLoginResponse(
        host: event.host,
        username: event.username,
        tokenResponse: loginResponse,
      ),
    );
    return ActionSuccess.consumer(event);
  }
}
