import 'dart:async';

import 'package:backend/model/model.dart' show Item, DLC, Game, Purchase;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository, PurchaseRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class DLCRelationBloc<W extends Item> extends ItemRelationBloc<DLC, W> {
  DLCRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required DLCRelationManagerBloc<W> managerBloc,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    this.purchaseRepository = collectionRepository.purchaseRepository,
    super(itemId: itemId, managerBloc: managerBloc);

  final GameRepository gameRepository;
  final PurchaseRepository purchaseRepository;

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return gameRepository.findBaseGameFromDLC(itemId).map<List<Game>>( (Game? game) => game != null? <Game>[game] : <Game>[] ) as Stream<List<W>>;
      case Purchase:
        return purchaseRepository.findAllPurchasesFromDLC(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}

class DLCFinishRelationBloc extends RelationBloc<DLC, DLCFinish> {
  DLCFinishRelationBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required DLCFinishRelationManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<DLCFinish>> getRelationStream() {

    return iCollectionRepository.findAllDLCFinishFromDLC(itemId);

  }
}