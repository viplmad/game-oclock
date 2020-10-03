import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';

class SystemSearchBloc extends ItemSearchBloc<System> {

  SystemSearchBloc({
    @required ICollectionRepository collectionRepository
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<System> createFuture(AddItem event) {

    return collectionRepository.insertSystem(event.title ?? '');

  }

  @override
  Future<List<System>> getInitialItems() {

    return collectionRepository.getSystemsWithView(SystemView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<System>> getSearchItems(String query) {

    return collectionRepository.getSystemsWithName(query, super.maxResults).first;

  }

}