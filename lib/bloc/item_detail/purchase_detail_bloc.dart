import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class PurchaseDetailBloc extends ItemDetailBloc<Purchase> {

  PurchaseDetailBloc({
    @required int purchaseID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: purchaseID, collectionRepository: collectionRepository);

  @override
  Stream<Purchase> getReadStream() {

    return collectionRepository.getPurchaseWithID(itemID);

  }

  @override
  Future<Purchase> updateFuture(UpdateItemField<Purchase> event) {

    return collectionRepository.updatePurchase(itemID, event.field, event.value);

  }

}