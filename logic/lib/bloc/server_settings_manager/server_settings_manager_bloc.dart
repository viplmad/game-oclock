import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode, TokenResponse;

import 'package:logic/model/model.dart' show ServerConnection;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/bloc_utils.dart';
import 'package:logic/preferences/shared_preferences_state.dart';

import 'server_settings_manager.dart';

class ServerSettingsManagerBloc
    extends Bloc<ServerSettingsManagerEvent, ServerSettingsManagerState> {
  ServerSettingsManagerBloc({required this.collectionService})
      : super(ServerSettingsManagerInitialised()) {
    on<SaveServerConnectionSettings>(_mapSaveToState);
    on<WarnServerSettingsNotLoaded>(_mapWarnNotLoadedToState);
  }

  final GameOClockService collectionService;

  void _mapSaveToState(
    SaveServerConnectionSettings event,
    Emitter<ServerSettingsManagerState> emit,
  ) async {
    try {
      final String host = event.host;
      final String username = event.username;

      // First test connection to host
      await GameOClockService.testConnection(host);
      // Then try to obtain login token with credentials
      final TokenResponse loginResponse = await collectionService.login(
        host,
        username,
        event.password,
      );

      final ServerConnection fullConnection = ServerConnection(
        name: event.name,
        host: host,
        username: username,
        tokenResponse: loginResponse,
      );
      // Save connection
      await SharedPreferencesState.setActiveServer(fullConnection);

      emit(
        ServerConnectionSettingsSaved(fullConnection),
      );
    } catch (e) {
      _handleError(e, emit);
    }

    emit(
      ServerSettingsManagerInitialised(),
    );
  }

  void _mapWarnNotLoadedToState(
    WarnServerSettingsNotLoaded event,
    Emitter<ServerSettingsManagerState> emit,
  ) {
    emit(ServerSettingsNotLoaded(event.error, event.errorDescription));

    emit(
      ServerSettingsManagerInitialised(),
    );
  }

  void _handleError(Object e, Emitter<ServerSettingsManagerState> emit) {
    BlocUtils.handleError(
      e,
      emit,
      (ErrorCode error, String errorDescription) =>
          ServerSettingsNotSaved(error, errorDescription),
    );
  }
}
