import 'package:bloc/bloc.dart';

import 'package:backend/preferences/repository_preferences.dart';

import 'repository_settings_manager.dart';

class RepositorySettingsManagerBloc extends Bloc<RepositorySettingsManagerEvent,
    RepositorySettingsManagerState> {
  RepositorySettingsManagerBloc() : super(Initialised()) {
    on<UpdateItemConnectionSettings>(_mapUpdateItemToState);
    on<UpdateImageConnectionSettings>(_mapUpdateImageToState);
    on<DeleteItemConnectionSettings>(_mapDeleteItemToState);
    on<DeleteImageConnectionSettings>(_mapDeleteImageToState);
  }

  void _mapUpdateItemToState(
    UpdateItemConnectionSettings event,
    Emitter<RepositorySettingsManagerState> emit,
  ) async {
    try {
      await RepositoryPreferences.setActiveItemConnectorType(event.type);
      await RepositoryPreferences.setActiveItemInstance(event.instance);

      emit(
        ItemConnectionSettingsUpdated(event.type),
      );
    } catch (e) {
      emit(
        RepositorySettingsNotUpdated(e.toString()),
      );
    }

    emit(
      Initialised(),
    );
  }

  void _mapUpdateImageToState(
    UpdateImageConnectionSettings event,
    Emitter<RepositorySettingsManagerState> emit,
  ) async {
    try {
      await RepositoryPreferences.setActiveImageConnectorType(event.type);
      await RepositoryPreferences.setActiveImageInstance(event.instance);

      emit(
        ImageConnectionSettingsUpdated(event.type),
      );
    } catch (e) {
      emit(
        RepositorySettingsNotUpdated(e.toString()),
      );
    }

    emit(
      Initialised(),
    );
  }

  void _mapDeleteItemToState(
    DeleteItemConnectionSettings event,
    Emitter<RepositorySettingsManagerState> emit,
  ) async {
    try {
      await RepositoryPreferences.setActiveItemConnectorType(null);
      await RepositoryPreferences.setActiveItemInstance(null);

      emit(
        ItemConnectionSettingsDeleted(),
      );
    } catch (e) {
      emit(
        RepositorySettingsNotDeleted(e.toString()),
      );
    }

    emit(
      Initialised(),
    );
  }

  void _mapDeleteImageToState(
    DeleteImageConnectionSettings event,
    Emitter<RepositorySettingsManagerState> emit,
  ) async {
    try {
      await RepositoryPreferences.setActiveImageConnectorType(null);
      await RepositoryPreferences.setActiveImageInstance(null);

      emit(
        ImageConnectionSettingsDeleted(),
      );
    } catch (e) {
      emit(
        RepositorySettingsNotDeleted(e.toString()),
      );
    }

    emit(
      Initialised(),
    );
  }
}
