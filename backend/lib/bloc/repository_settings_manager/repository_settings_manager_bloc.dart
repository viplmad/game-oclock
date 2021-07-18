import 'package:bloc/bloc.dart';

import 'package:backend/preferences/repository_preferences.dart';

import 'repository_settings_manager.dart';


class RepositorySettingsManagerBloc extends Bloc<RepositorySettingsManagerEvent, RepositorySettingsManagerState> {
  RepositorySettingsManagerBloc() : super(Initialised());

  @override
  Stream<RepositorySettingsManagerState> mapEventToState(RepositorySettingsManagerEvent event) async* {

    if(event is UpdateConnectionSettings) {

      yield* _mapUpdateRemoteToState(event);

    }

    yield Initialised();

  }

  Stream<RepositorySettingsManagerState> _mapUpdateRemoteToState(UpdateConnectionSettings event) async* {

    try {

      await RepositoryPreferences.setPostgresConnector(event.postgresInstance);
      await RepositoryPreferences.setCloudinaryConnector(event.cloudinaryInstance);

      await RepositoryPreferences.setRepositoryExist();

      yield RepositorySettingsUpdated();

    } catch(e) {

      yield RepositorySettingsNotUpdated(e.toString());

    }

  }
}