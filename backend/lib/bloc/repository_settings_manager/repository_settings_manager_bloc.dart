import 'package:bloc/bloc.dart';

import 'package:backend/preferences/repository_preferences.dart';

import 'repository_settings_manager.dart';


class RepositorySettingsManagerBloc extends Bloc<RepositorySettingsManagerEvent, RepositorySettingsManagerState> {
  RepositorySettingsManagerBloc() : super(Initialised());

  @override
  Stream<RepositorySettingsManagerState> mapEventToState(RepositorySettingsManagerEvent event) async* {

    if(event is UpdateItemConnectionSettings) {

      yield* _mapUpdateItemToState(event);

    } else if(event is UpdateImageConnectionSettings) {

      yield* _mapUpdateImageToState(event);

    }

    yield Initialised();

  }

  Stream<RepositorySettingsManagerState> _mapUpdateItemToState(UpdateItemConnectionSettings event) async* {

    try {

      await RepositoryPreferences.setActiveItemConnectorType(event.type);
      await RepositoryPreferences.setItemInstance(event.instance);

      yield ItemConnectionSettingsUpdated(event.type);

    } catch(e) {

      yield RepositorySettingsNotUpdated(e.toString());

    }

  }

  Stream<RepositorySettingsManagerState> _mapUpdateImageToState(UpdateImageConnectionSettings event) async* {

    try {

      await RepositoryPreferences.setActiveImageConnectorType(event.type);
      await RepositoryPreferences.setImageInstance(event.instance);

      yield ImageConnectionSettingsUpdated(event.type);

    } catch(e) {

      yield RepositorySettingsNotUpdated(e.toString());

    }

  }
}