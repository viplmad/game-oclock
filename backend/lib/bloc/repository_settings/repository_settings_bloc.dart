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

    on<LoadRepositorySettings>(_mapLoadToState);
    on<UpdateRepositorySettings>(_mapUpdateToState);

    managerSubscription = managerBloc.stream.listen(mapManagerStateToEvent);

  }

  late final StreamSubscription<RepositorySettingsManagerState> managerSubscription;

  void _mapLoadToState(LoadRepositorySettings event, Emitter<RepositorySettingsState> emit) async {

    emit(
      RepositorySettingsLoading(),
    );

    final bool existsConnection = await RepositoryPreferences.existsConnection();
    if(!existsConnection) {

      emit(
        const RepositorySettingsLoaded(),
      );

    } else {

      try {

        emit(
          RepositorySettingsLoaded(
            await RepositoryPreferences.retrieveActiveItemConnectorType(),
            await RepositoryPreferences.retrieveActiveImageConnectorType(),
          ),
        );

      } catch(e) {

        emit(
          RepositorySettingsNotLoaded(e.toString()),
        );

      }

    }

  }

  void _mapUpdateToState(UpdateRepositorySettings event, Emitter<RepositorySettingsState> emit) {

    emit(
      RepositorySettingsLoaded(
        event.savedItemConnection,
        event.savedImageConnection,
      ),
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