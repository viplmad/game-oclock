import 'package:bloc/bloc.dart';

import 'package:backend/preferences/repository_preferences.dart';

import 'repository_settings.dart';


class RepositorySettingsBloc extends Bloc<RepositorySettingsEvent, RepositorySettingsState> {
  RepositorySettingsBloc() : super(RepositorySettingsLoading());

  @override
  Stream<RepositorySettingsState> mapEventToState(RepositorySettingsEvent event) async* {

    if(event is LoadRepositorySettings) {

      yield* _mapLoadToState();

    }

  }

  Stream<RepositorySettingsState> _mapLoadToState() async* {

    yield RepositorySettingsLoading();

    final bool existsConnection = await RepositoryPreferences.existsRepository();
    if(!existsConnection) {

      yield EmptyRepositorySettings();

    } else {

      try {

        yield RepositorySettingsLoaded(
          await RepositoryPreferences.retrieveItemConnectorType(),
          await RepositoryPreferences.retrieveItemConnector(),
          await RepositoryPreferences.retrieveImageConnectorType(),
          await RepositoryPreferences.retrieveImageConnector(),
        );

      } catch(e) {

        yield EmptyRepositorySettings();

      }

    }

  }
}