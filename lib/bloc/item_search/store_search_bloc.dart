import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


class StoreSearchBloc extends ItemSearchBloc<Store> {

  StoreSearchBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Store> createFuture(AddItem event) {

    return iCollectionRepository.insertStore(event.title ?? '');

  }

  @override
  Future<List<Store>> getInitialItems() {

    return iCollectionRepository.getStoresWithView(StoreView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Store>> getSearchItems(String query) {

    return iCollectionRepository.getStoresWithName(query, super.maxResults).first;

  }

}