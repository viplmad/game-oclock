import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class PurchaseDetailBloc extends ItemDetailBloc<Purchase> {

  PurchaseDetailBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<Purchase> getReadStream() {

    return iCollectionRepository.getPurchaseWithID(itemID);

  }

  @override
  Future<Purchase> updateFuture(UpdateItemField<Purchase> event) {

    return iCollectionRepository.updatePurchase(itemID, event.field, event.value);

  }

}