import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_search.dart';


class StoreSearchBloc extends ItemSearchBloc<Store> {
  StoreSearchBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<Store>> getInitialItems() {

    return iCollectionRepository!.findAllStoresWithView(StoreView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Store>> getSearchItems(String query) {

    return iCollectionRepository!.findAllStoresByName(query, super.maxResults).first;

  }
}