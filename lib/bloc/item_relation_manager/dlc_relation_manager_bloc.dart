import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

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
        return iCollectionRepository.deleteGameDLC(itemId);
      case Purchase:
        return iCollectionRepository.deleteDLCPurchase(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}

class DLCFinishDateRelationManagerBloc extends RelationManagerBloc<DLC, DateTime> {
  DLCFinishDateRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddRelation<DateTime> event) {

    return iCollectionRepository.relateDLCFinishDate(itemId, event.otherItem);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteRelation<DateTime> event) {

    return iCollectionRepository.deleteDLCFinishDate(itemId, event.otherItem);

  }
}