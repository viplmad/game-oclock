import 'package:bloc/bloc.dart';

import 'package:game_collection/preferences/repository_preferences.dart';

import 'repository_settings_manager.dart';


class RepositorySettingsManagerBloc extends Bloc<RepositorySettingsManagerEvent, RepositorySettingsManagerState> {
  RepositorySettingsManagerBloc() : super(Initialised());

  @override
  Stream<RepositorySettingsManagerState> mapEventToState(RepositorySettingsManagerEvent event) async* {

    if(event is UpdateRemoteConnectionSettings) {

      yield* _mapUpdateRemoteToState(event);

    }/* else if(event is UpdateLocalConnectionSettings) {

      yield* _mapUpdateLocalToState();

    }*/

    yield Initialised();

  }

  Stream<RepositorySettingsManagerState> _mapUpdateRemoteToState(UpdateRemoteConnectionSettings event) async* {

    try {

      await RepositoryPreferences.setPostgresConnector(event.postgresInstance);
      await RepositoryPreferences.setCloudinaryConnector(event.cloudinaryInstance);

      await RepositoryPreferences.setRepositoryTypeRemote();
      await RepositoryPreferences.setRepositoryExist();

      yield RepositorySettingsUpdated();

    } catch(e) {

      yield RepositorySettingsNotUpdated(e.toString());

    }

  }
}