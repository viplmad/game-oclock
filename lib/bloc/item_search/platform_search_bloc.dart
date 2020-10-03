import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';

class PlatformSearchBloc extends ItemSearchBloc<Platform> {

  PlatformSearchBloc({
    @required ICollectionRepository collectionRepository
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Platform> createFuture(AddItem event) {

    return collectionRepository.insertPlatform(event.title ?? '');

  }

  @override
  Future<List<Platform>> getInitialItems() {

    return collectionRepository.getPlatformsWithView(PlatformView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<Platform>> getSearchItems(String query) {

    return collectionRepository.getPlatformsWithName(query, super.maxResults).first;

  }

}