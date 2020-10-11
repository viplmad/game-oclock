import 'package:bloc/bloc.dart';

import 'package:game_collection/preferences/repository_preferences.dart';

import 'package:game_collection/repository/icollection_repository.dart';
import 'package:game_collection/repository/remote_repository.dart';

import 'repository_settings.dart';


class RepositorySettingsBloc extends Bloc<RepositorySettingsEvent, RepositorySettingsState> {

  RepositorySettingsBloc() : super(RepositorySettingsLoading());

  @override
  Stream<RepositorySettingsState> mapEventToState(RepositorySettingsEvent event) async* {

    if(event is LoadRepositorySettings) {

      yield* _mapLoadToState();

    } else if(event is UpdateRemoteConnectionSettings) {

      yield* _mapUpdateRemoteToState(event);

    }/* else if(event is UpdateLocalConnectionSettings) {

      yield* _mapUpdateLocalToState();

    }*/

  }

  Stream<RepositorySettingsState> _mapLoadToState() async* {

    yield RepositorySettingsLoading();

    bool existsConnection = await RepositoryPreferences.existsRepository();
    if(!existsConnection) {

      yield EmptyRepositorySettings();

    } else {

      try {

        ICollectionRepository iCollectionRepository = await RepositoryPreferences.retrieveRepository();

        if(iCollectionRepository is RemoteRepository) {

          yield RemoteRepositorySettingsLoaded(
            await RepositoryPreferences.retrievePostgresInstance(),
            await RepositoryPreferences.retrieveCloudinaryInstance(),
          );

        }

      } catch(e) {

        yield EmptyRepositorySettings();

      }

    }

  }

  Stream<RepositorySettingsState> _mapUpdateRemoteToState(UpdateRemoteConnectionSettings event) async* {

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