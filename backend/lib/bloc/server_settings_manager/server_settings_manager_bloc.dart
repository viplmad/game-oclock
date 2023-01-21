import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show TokenResponse;

import 'package:backend/service/service.dart' show GameCollectionService;
import 'package:backend/model/model.dart' show ServerConnection;
import 'package:backend/preferences/shared_preferences_state.dart';

import 'server_settings_manager.dart';

class ServerSettingsManagerBloc
    extends Bloc<ServerSettingsManagerEvent, ServerSettingsManagerState> {
  ServerSettingsManagerBloc({required this.collectionService})
      : super(Initialised()) {
    on<SaveServerConnectionSettings>(_mapSaveToState);
    on<WarnServerSettingsNotLoaded>(_mapWarnNotLoadedToState);
  }

  final GameCollectionService collectionService;

  void _mapSaveToState(
    SaveServerConnectionSettings event,
    Emitter<ServerSettingsManagerState> emit,
  ) async {
    try {
      final String host = event.host;
      final String username = event.username;

      // First test connection to host
      await GameCollectionService.testConnection(host);
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
      await SharedPreferencesState.setActiveServer(fullConnection);

      emit(
        ServerConnectionSettingsSaved(fullConnection),
      );
    } catch (e) {
      emit(
        ServerSettingsNotSaved(e.toString()),
      );
    }

    emit(
      Initialised(),
    );
  }

  void _mapWarnNotLoadedToState(
    WarnServerSettingsNotLoaded event,
    Emitter<ServerSettingsManagerState> emit,
  ) {
    emit(ServerSettingsNotLoaded(event.error));
  }
}
