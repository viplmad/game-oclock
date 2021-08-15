import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:backend/model/repository_type.dart';
import 'package:backend/preferences/repository_preferences.dart';

import '../repository_settings_manager/repository_settings_manager.dart';
import 'repository_settings.dart';


class RepositorySettingsBloc extends Bloc<RepositorySettingsEvent, RepositorySettingsState> {
  RepositorySettingsBloc({
    required RepositorySettingsManagerBloc managerBloc,
  }) : super(RepositorySettingsLoading()) {

    managerSubscription = managerBloc.stream.listen(mapManagerStateToEvent);

  }

  late final StreamSubscription<RepositorySettingsManagerState> managerSubscription;

  @override
  Stream<RepositorySettingsState> mapEventToState(RepositorySettingsEvent event) async* {

    if(event is LoadRepositorySettings) {

      yield* _mapLoadToState();

    } else if(event is UpdateRepositorySettings) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<RepositorySettingsState> _mapLoadToState() async* {

    yield RepositorySettingsLoading();

    final bool existsConnection = await RepositoryPreferences.existsConnection();
    if(!existsConnection) {

      yield const RepositorySettingsLoaded();

    } else {

      try {

        yield RepositorySettingsLoaded(
          await RepositoryPreferences.retrieveActiveItemConnectorType(),
          await RepositoryPreferences.retrieveActiveImageConnectorType(),
        );

      } catch(e) {

        yield RepositorySettingsNotLoaded(e.toString());

      }

    }

  }

  Stream<RepositorySettingsState> _mapUpdateToState(UpdateRepositorySettings event) async* {

    yield RepositorySettingsLoaded(
      event.savedItemConnection,
      event.savedImageConnection,
    );

  }

  void mapManagerStateToEvent(RepositorySettingsManagerState managerState) {

    if(managerState is ItemConnectionSettingsUpdated) {

      _mapUpdatedItemToEvent(managerState);

    } else if(managerState is ImageConnectionSettingsUpdated) {

      _mapUpdatedImageToEvent(managerState);

    }

  }

  void _mapUpdatedItemToEvent(ItemConnectionSettingsUpdated managerState) {

    if(state is RepositorySettingsLoaded) {
      final ImageConnectorType? imageType = (state as RepositorySettingsLoaded).activeImageConnection;

      add(UpdateRepositorySettings(
        managerState.type,
        imageType,
      ));
    }
  }

  void _mapUpdatedImageToEvent(ImageConnectionSettingsUpdated managerState) {

    if(state is RepositorySettingsLoaded) {
      final ItemConnectorType? itemType = (state as RepositorySettingsLoaded).activeItemConnection;

      add(UpdateRepositorySettings(
        itemType,
        managerState.type,
      ));
    }

  }

  @override
  Future<void> close() {

    managerSubscription.cancel();
    return super.close();

  }

}