import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


class PurchaseSearchBloc extends ItemSearchBloc<Purchase> {
  PurchaseSearchBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<Purchase>> getInitialItems() {

    return iCollectionRepository!.getPurchasesWithView(PurchaseView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Purchase>> getSearchItems(String query) {

    return iCollectionRepository!.getPurchasesWithDescription(query, super.maxResults).first;

  }
}