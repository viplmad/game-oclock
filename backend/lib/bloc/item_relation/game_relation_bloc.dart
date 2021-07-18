import 'dart:async';

import 'package:backend/model/model.dart' show Item, Game, DLC, Platform, Purchase, Tag;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository, DLCRepository, PlatformRepository, PurchaseRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class GameRelationBloc<W extends Item> extends ItemRelationBloc<Game, W> {
  GameRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required GameRelationManagerBloc<W> managerBloc,
  }) :
    this.dlcRepository = collectionRepository.dlcRepository,
    this.platformRepository = collectionRepository.platformRepository,
    this.purchaseRepository = collectionRepository.purchaseRepository,
    this.gameTagRepository = collectionRepository.gameTagRepository,
    super(itemId: itemId, managerBloc: managerBloc);

  final DLCRepository dlcRepository;
  final PlatformRepository platformRepository;
  final PurchaseRepository purchaseRepository;
  final GameTagRepository gameTagRepository;

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case DLC:
        return dlcRepository.findAllDLCsFromGame(itemId) as Stream<List<W>>;
      case Platform:
        return platformRepository.findAllPlatformsFromGame(itemId) as Stream<List<W>>;
      case Purchase:
        return purchaseRepository.findAllPurchasesFromGame(itemId) as Stream<List<W>>;
      case Tag:
        return gameTagRepository.findAllGameTagsFromGame(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}

class GameFinishRelationBloc extends RelationBloc<Game, GameFinish> {
  GameFinishRelationBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required GameFinishRelationManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<GameFinish>> getRelationStream() {

    return iCollectionRepository.findAllGameFinishFromGame(itemId);

  }
}