import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';

class PurchaseSearchBloc extends ItemSearchBloc<Purchase> {

  PurchaseSearchBloc({
    @required ICollectionRepository collectionRepository
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Purchase> createFuture(AddItem event) {

    return collectionRepository.insertPurchase(event.title ?? '');

  }

  @override
  Future<List<Purchase>> getInitialItems() {

    return collectionRepository.getPurchasesWithView(PurchaseView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<Purchase>> getSearchItems(String query) {

    return collectionRepository.getPurchasesWithDescription(query, super.maxResults).first;

  }

}