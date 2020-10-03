import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';

class DLCSearchBloc extends ItemSearchBloc<DLC> {

  DLCSearchBloc({
    @required ICollectionRepository collectionRepository
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<DLC> createFuture(AddItem event) {

    return collectionRepository.insertDLC(event.title ?? '');

  }

  @override
  Future<List<DLC>> getInitialItems() {

    return collectionRepository.getDLCsWithView(DLCView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<DLC>> getSearchItems(String query) {

    return collectionRepository.getDLCsWithName(query, super.maxResults).first;

  }

}