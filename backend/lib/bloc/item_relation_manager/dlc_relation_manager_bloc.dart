import 'package:backend/model/model.dart' show Item, DLC, Game, Purchase;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository, GameRepository;

import 'item_relation_manager.dart';


class DLCRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<DLC, W> {
  DLCRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    this.dlcRepository = collectionRepository.dlcRepository,
    super(itemId: itemId);

  final GameRepository gameRepository;
  final DLCRepository dlcRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return gameRepository.relateGameDLC(otherId, itemId);
      case Purchase:
        return dlcRepository.relateDLCPurchase(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return gameRepository.unrelateGameDLC(itemId);
      case Purchase:
        return dlcRepository.unrelateDLCPurchase(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}

class DLCFinishRelationManagerBloc extends RelationManagerBloc<DLC, DLCFinish> {
  DLCFinishRelationManagerBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
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