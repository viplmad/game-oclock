import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


class PlatformSearchBloc extends ItemSearchBloc<Platform> {

  PlatformSearchBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Platform> createFuture(AddItem event) {

    return iCollectionRepository.insertPlatform(event.title ?? '');

  }

  @override
  Future<List<Platform>> getInitialItems() {

    return iCollectionRepository.getPlatformsWithView(PlatformView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Platform>> getSearchItems(String query) {

    return iCollectionRepository.getPlatformsWithName(query, super.maxResults).first;

  }

}