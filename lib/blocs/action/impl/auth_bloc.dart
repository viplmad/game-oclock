import 'package:game_oclock/models/models.dart' show Login, SavedLoginResponse;
import 'package:game_oclock/services/services.dart'
    show AuthService, LoginService, RetryableApiClient, UserService;
import 'package:game_oclock_client/api.dart';

import '../action.dart' show ConsumerActionBloc, ProducerActionBloc;

class CurrentUserGetBloc extends ProducerActionBloc<UserDTO> {
  CurrentUserGetBloc({required this.service});

  final UserService service;

  @override
  Future<UserDTO> doAction(final void event, final UserDTO? lastData) =>
      service.getCurrent();
}

class CurrentLoginResponseGetBloc
    extends ProducerActionBloc<SavedLoginResponse> {
  CurrentLoginResponseGetBloc({required this.service});

  final AuthService service;

  @override
  Future<SavedLoginResponse> doAction(
    final void event,
    final SavedLoginResponse? lastData,
  ) => service.getCurrent();
}

class LoginBloc extends ConsumerActionBloc<Login> {
  LoginBloc({required this.service, required this.apiClient});

  final AuthService service;
  final RetryableApiClient apiClient;

  @override
  Future<void> doAction(final Login event, final void lastData) async {
    final loginResponse = await LoginService(
      ApiClient(basePath: event.host),
    ).login(event.username, event.password);
    apiClient.update(
      basePath: event.host,
      authentication: OAuth(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      ),
      onRefresh: (final client, final oauth) async {
        final refreshResponse = await LoginService(
          ApiClient(basePath: client.basePath),
        ).refresh(oauth.refreshToken);
        return OAuth(
          accessToken: refreshResponse.accessToken,
          refreshToken: refreshResponse.refreshToken,
        );
      },
    );
    return service.saveCurrent(
      SavedLoginResponse(
        host: event.host,
        username: event.username,
        tokenResponse: loginResponse,
      ),
    );
  }
}
