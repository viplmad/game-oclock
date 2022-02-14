import 'package:bloc/bloc.dart';

import 'package:backend/connector/provider_instance.dart';
import 'package:backend/model/repository_type.dart';
import 'package:backend/preferences/repository_preferences.dart';

import 'repository_settings_detail.dart';

class RepositorySettingsDetailBloc
    extends Bloc<RepositorySettingsDetailEvent, RepositorySettingsDetailState> {
  RepositorySettingsDetailBloc() : super(RepositorySettingsDetailLoading()) {
    on<LoadItemSettingsDetail>(_mapLoadItemToState);
    on<LoadImageSettingsDetail>(_mapLoadImageToState);
  }

  void _mapLoadItemToState(
    LoadItemSettingsDetail event,
    Emitter<RepositorySettingsDetailState> emit,
  ) async {
    emit(
      RepositorySettingsDetailLoading(),
    );

    try {
      final ItemConnectorType? activeItemType =
          await RepositoryPreferences.retrieveActiveItemConnectorType();

      ProviderInstance? instance;
      if (activeItemType == event.itemType) {
        instance = await RepositoryPreferences.retrieveActiveItemInstance();
      }

      emit(
        RepositorySettingsDetailLoaded(instance),
      );
    } catch (e) {
      emit(
        RepositorySettingsDetailNotLoaded(e.toString()),
      );
    }
  }

  void _mapLoadImageToState(
    LoadImageSettingsDetail event,
    Emitter<RepositorySettingsDetailState> emit,
  ) async {
    emit(
      RepositorySettingsDetailLoading(),
    );

    try {
      final ImageConnectorType? activeImageType =
          await RepositoryPreferences.retrieveActiveImageConnectorType();

      ProviderInstance? instance;
      if (activeImageType == event.imageType) {
        instance = await RepositoryPreferences.retrieveActiveImageInstance();
      }

      emit(
        RepositorySettingsDetailLoaded(instance),
      );
    } catch (e) {
      emit(
        RepositorySettingsDetailNotLoaded(e.toString()),
      );
    }
  }
}
