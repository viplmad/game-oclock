import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class DLCRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<DLC, W> {
  DLCRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.relateGameDLC(otherId, itemId);
      case Purchase:
        return iCollectionRepository.relateDLCPurchase(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.unrelateGameDLC(itemId);
      case Purchase:
        return iCollectionRepository.unrelateDLCPurchase(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}

class DLCFinishRelationManagerBloc extends RelationManagerBloc<DLC, DLCFinish> {
  DLCFinishRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddRelation<DLCFinish> event) {

    return iCollectionRepository.createDLCFinish(itemId, event.otherItem);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteRelation<DLCFinish> event) {

    return iCollectionRepository.deleteDLCFinishById(itemId, event.otherItem.dateTime);

  }
}