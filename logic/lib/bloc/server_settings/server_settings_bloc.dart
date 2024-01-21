import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

import 'package:logic/bloc/bloc_utils.dart';
import 'package:logic/preferences/shared_preferences_state.dart';

import '../server_settings_manager/server_settings_manager.dart';
import 'server_settings.dart';

class ServerSettingsBloc
    extends Bloc<ServerSettingsEvent, ServerSettingsState> {
  ServerSettingsBloc({required this.managerBloc})
      : super(ServerSettingsLoading()) {
    on<LoadServerSettings>(_mapLoadToState);
    on<ReloadServerSettings>(_mapReloadToState);
    on<UpdateServerSettings>(_mapUpdateToState);

    _managerSubscription = managerBloc.stream.listen(_mapManagerStateToEvent);
  }

  final ServerSettingsManagerBloc managerBloc;

  late final StreamSubscription<ServerSettingsManagerState>
      _managerSubscription;

  void _mapLoadToState(
    LoadServerSettings event,
    Emitter<ServerSettingsState> emit,
  ) async {
    emit(
      ServerSettingsLoading(),
    );

    await _mapAnyLoadToState(emit);
  }

  void _mapReloadToState(
    ReloadServerSettings event,
    Emitter<ServerSettingsState> emit,
  ) async {
    emit(
      ServerSettingsLoading(),
    );

    await _mapAnyLoadToState(emit);
  }

  Future<void> _mapAnyLoadToState(Emitter<ServerSettingsState> emit) async {
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
        _handleError(e, emit);
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

  void _handleError(Object e, Emitter<ServerSettingsState> emit) {
    BlocUtils.handleErrorWithManager(
      e,
      emit,
      managerBloc,
      () => ServerSettingsError(),
      (ErrorCode error, String errorDescription) =>
          WarnServerSettingsNotLoaded(error, errorDescription),
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
    _managerSubscription.cancel();
    return super.close();
  }
}
