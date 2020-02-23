import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'item.dart';


class TypeBloc extends ItemBloc {

  TypeBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<PurchaseType> createFuture(AddItem event) {

    return collectionRepository.insertType(event.item != null? event.item.getTitle() : '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deleteType(event.item.ID);

  }

  @override
  Future<Tag> updateFuture(UpdateItemField event) {

    return collectionRepository.updateTag(event.item.ID, event.field, event.value);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int typeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case purchaseTable:
        return collectionRepository.insertPurchaseType(otherID, typeID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int typeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case purchaseTable:
        return collectionRepository.deletePurchaseType(otherID, typeID);
    }

    return super.deleteRelationFuture(event);

  }

}