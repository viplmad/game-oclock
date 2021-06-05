import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class GameRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Game, W> {
  GameRelationBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required GameRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case DLC:
        return iCollectionRepository.findAllDLCsFromGame(itemId) as Stream<List<W>>;
      case Purchase:
        return iCollectionRepository.findAllPurchasesFromGame(itemId) as Stream<List<W>>;
      case Platform:
        return iCollectionRepository.findAllPlatformsFromGame(itemId) as Stream<List<W>>;
      case Tag:
        return iCollectionRepository.findAllGameTagsFromGame(itemId) as Stream<List<W>>;
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