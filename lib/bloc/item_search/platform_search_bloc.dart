import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


class PlatformSearchBloc extends ItemSearchBloc<Platform> {
  PlatformSearchBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<Platform>> getInitialItems() {

    return iCollectionRepository!.findAllPlatformsWithView(PlatformView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Platform>> getSearchItems(String query) {

    return iCollectionRepository!.findAllPlatformsByName(query, super.maxResults).first;

  }
}