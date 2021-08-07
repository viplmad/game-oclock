import 'package:bloc/bloc.dart';


import 'package:backend/connector/provider_instance.dart';
import 'package:backend/model/repository_type.dart';
import 'package:backend/preferences/repository_preferences.dart';

import 'repository_settings_detail.dart';


class RepositorySettingsDetailBloc extends Bloc<RepositorySettingsDetailEvent, RepositorySettingsDetailState> {
  RepositorySettingsDetailBloc() : super(RepositorySettingsDetailLoading());

  @override
  Stream<RepositorySettingsDetailState> mapEventToState(RepositorySettingsDetailEvent event) async* {

    if(event is LoadItemSettingsDetail) {

      yield* _mapLoadItemToState(event);

    } else if(event is LoadImageSettingsDetail) {

      yield* _mapLoadImageToState(event);

    }
  }

  Stream<RepositorySettingsDetailState> _mapLoadItemToState(LoadItemSettingsDetail event) async* {

    yield RepositorySettingsDetailLoading();

    try {

      final ItemConnectorType activeItemType = await RepositoryPreferences.retrieveActiveItemConnectorType();

      ProviderInstance? instance;
      if(activeItemType == event.itemType) {
        instance = await RepositoryPreferences.retrieveActiveItemInstance();
      }

      yield RepositorySettingsDetailLoaded(instance);

    } catch(e) {

      yield RepositorySettingsDetailNotLoaded(e.toString());

    }

  }

  Stream<RepositorySettingsDetailState> _mapLoadImageToState(LoadImageSettingsDetail event) async* {

    yield RepositorySettingsDetailLoading();

    try {

      final ImageConnectorType activeImageType = await RepositoryPreferences.retrieveActiveImageConnectorType();

      ProviderInstance? instance;
      if(activeImageType == event.imageType) {
        instance = await RepositoryPreferences.retrieveActiveImageInstance();
      }

      yield RepositorySettingsDetailLoaded(instance);

    } catch(e) {

      yield RepositorySettingsDetailNotLoaded(e.toString());

    }

  }

}