import 'package:bloc/bloc.dart';

import 'package:backend/preferences/repository_preferences.dart';

import 'repository_settings_manager.dart';


class RepositorySettingsManagerBloc extends Bloc<RepositorySettingsManagerEvent, RepositorySettingsManagerState> {
  RepositorySettingsManagerBloc() : super(Initialised()) {

    on<UpdateItemConnectionSettings>(_mapUpdateItemToState);
    on<UpdateImageConnectionSettings>(_mapUpdateImageToState);

  }

  void _mapUpdateItemToState(UpdateItemConnectionSettings event, Emitter<RepositorySettingsManagerState> emit) async {

    try {

      await RepositoryPreferences.setActiveItemConnectorType(event.type);
      await RepositoryPreferences.setItemInstance(event.instance);

      emit(
        ItemConnectionSettingsUpdated(event.type),
      );

    } catch(e) {

      emit(
        RepositorySettingsNotUpdated(e.toString()),
      );

    }

    emit(
      Initialised(),
    );

  }

  void _mapUpdateImageToState(UpdateImageConnectionSettings event, Emitter<RepositorySettingsManagerState> emit) async {

    try {

      await RepositoryPreferences.setActiveImageConnectorType(event.type);
      await RepositoryPreferences.setImageInstance(event.instance);

      emit(
        ImageConnectionSettingsUpdated(event.type),
      );

    } catch(e) {

      emit(
        RepositorySettingsNotUpdated(e.toString()),
      );

    }

    emit(
      Initialised(),
    );

  }
}