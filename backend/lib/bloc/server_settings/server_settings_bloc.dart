import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:backend/preferences/shared_preferences_state.dart';

import '../server_settings_manager/server_settings_manager.dart';
import 'server_settings.dart';

class ServerSettingsBloc
    extends Bloc<ServerSettingsEvent, ServerSettingsState> {
  ServerSettingsBloc({required this.managerBloc})
      : super(ServerSettingsLoading()) {
    on<LoadServerSettings>(_mapLoadToState);
    on<UpdateServerSettings>(_mapUpdateToState);

    managerSubscription = managerBloc.stream.listen(_mapManagerStateToEvent);
  }

  final ServerSettingsManagerBloc managerBloc;
  late final StreamSubscription<ServerSettingsManagerState> managerSubscription;

  void _mapLoadToState(
    LoadServerSettings event,
    Emitter<ServerSettingsState> emit,
  ) async {
    emit(
      ServerSettingsLoading(),
    );

    final bool existsConnection =
        await SharedPreferencesState.existsActiveServer();
    if (existsConnection) {
      try {
        emit(
          ServerSettingsLoaded(
            await SharedPreferencesState.retrieveActiveServer(),
          ),
        );
      } catch (e) {
        managerBloc.add(WarnServerSettingsNotLoaded(e.toString()));
        emit(ServerSettingsError());
      }
    } else {
      emit(
        const ServerSettingsLoaded(),
      );
    }
  }

  void _mapUpdateToState(
    UpdateServerSettings event,
    Emitter<ServerSettingsState> emit,
  ) {
    emit(
      ServerSettingsLoaded(
        event.savedServerConnection,
      ),
    );
  }

  void _mapManagerStateToEvent(ServerSettingsManagerState managerState) {
    if (managerState is ServerConnectionSettingsSaved) {
      _mapSavedServerToEvent(managerState);
    }
  }

  void _mapSavedServerToEvent(ServerConnectionSettingsSaved managerState) {
    add(UpdateServerSettings(managerState.connection));
  }

  @override
  Future<void> close() {
    managerSubscription.cancel();
    return super.close();
  }
}
