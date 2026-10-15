import 'package:game_oclock/models/models.dart' show Login, SavedLoginResponse;
import 'package:game_oclock/services/services.dart'
    show AuthService, LoginService, RetryableApiClient, UserService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, IdentityActionBloc, ProducerActionBloc;

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

class InitApiClientBloc extends ConsumerActionBloc<SavedLoginResponse> {
  InitApiClientBloc({required this.apiClient});

  final RetryableApiClient apiClient;

  @override
  Future<void> doAction(
    final SavedLoginResponse event,
    final void lastData,
  ) async {
    if (apiClient.apiClient != null) {
      return;
    }

    apiClient.update(
      basePath: event.host,
      authentication: OAuth(
        accessToken: event.tokenResponse.accessToken,
        refreshToken: event.tokenResponse.refreshToken,
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
  }
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
    return service.saveCurrent(
      SavedLoginResponse(
        host: event.host,
        username: event.username,
        tokenResponse: loginResponse,
      ),
    );
  }
}

class LogoutBloc extends IdentityActionBloc<void> {
  LogoutBloc({required this.service, required this.apiClient});

  final AuthService service;
  final RetryableApiClient apiClient;

  @override
  Future<void> doAction(final void event, final void lastData) async {
    apiClient.update(
      basePath: 'fake',
      authentication: OAuth(accessToken: 'access', refreshToken: 'refresh'),
      onRefresh: null,
    );
    return service.removeCurrent();
  }
}
