import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';

class StoreSearchBloc extends ItemSearchBloc<Store> {

  StoreSearchBloc({
    @required ICollectionRepository collectionRepository
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Store> createFuture(AddItem event) {

    return collectionRepository.insertStore(event.title ?? '');

  }

  @override
  Future<List<Store>> getInitialItems() {

    return collectionRepository.getStoresWithView(StoreView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<Store>> getSearchItems(String query) {

    return collectionRepository.getStoresWithName(query, super.maxResults).first;

  }

}