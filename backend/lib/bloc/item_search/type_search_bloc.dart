import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_search.dart';


class TypeSearchBloc extends ItemSearchBloc<PurchaseType> {
  TypeSearchBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<PurchaseType>> getInitialItems() {

    return iCollectionRepository!.findAllPurchaseTypesWithView(TypeView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<PurchaseType>> getSearchItems(String query) {

    return iCollectionRepository!.findAllPurchaseTypesByName(query, super.maxResults).first;

  }
}