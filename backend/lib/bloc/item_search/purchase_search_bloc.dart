import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_search.dart';


class PurchaseSearchBloc extends ItemSearchBloc<Purchase> {
  PurchaseSearchBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<Purchase>> getInitialItems() {

    return iCollectionRepository!.findAllPurchasesWithView(PurchaseView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Purchase>> getSearchItems(String query) {

    return iCollectionRepository!.findAllPurchasesByDescription(query, super.maxResults).first;

  }
}