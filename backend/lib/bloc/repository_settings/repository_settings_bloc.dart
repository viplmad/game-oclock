import 'package:bloc/bloc.dart';

import 'package:backend/preferences/repository_preferences.dart';

import 'package:backend/model/repository_type.dart';

import 'repository_settings.dart';


class RepositorySettingsBloc extends Bloc<RepositorySettingsEvent, RepositorySettingsState> {
  RepositorySettingsBloc() : super(RepositorySettingsLoading());

  @override
  Stream<RepositorySettingsState> mapEventToState(RepositorySettingsEvent event) async* {

    if(event is LoadRepositorySettings) {

      yield* _mapLoadToState();

    } else if(event is UpdateRepositorySettingsRadio) {

      yield* _mapUpdateRadioToState(event);

    }

  }

  Stream<RepositorySettingsState> _mapLoadToState() async* {

    yield RepositorySettingsLoading();

    final bool existsConnection = await RepositoryPreferences.existsRepository();
    if(!existsConnection) {

      yield EmptyRepositorySettings();

    } else {

      try {

        final RepositoryType repositoryType = await RepositoryPreferences.retrieveRepositoryType();

        yield* _mapRepositoryTypeToState(repositoryType);

      } catch(e) {

        yield EmptyRepositorySettings();

      }

    }

  }

  Stream<RepositorySettingsState> _mapUpdateRadioToState(UpdateRepositorySettingsRadio event) async* {

    yield* _mapRepositoryTypeToState(event.radio);

  }

  Stream<RepositorySettingsState> _mapRepositoryTypeToState(RepositoryType type) async* {

    switch(type) {
      case RepositoryType.Remote:
        yield* _remoteRepositoryState();
        break;
      case RepositoryType.Local:
        //yield* _localRepositoryState();
        break;
    }

  }

  Stream<RepositorySettingsState> _remoteRepositoryState() async* {

    yield RemoteRepositorySettingsLoaded(
      await RepositoryPreferences.retrievePostgresInstance(),
      await RepositoryPreferences.retrieveCloudinaryInstance(),
    );

  }

  /*Stream<RepositorySettingsState> _localRepositoryState() async* {}*/
}