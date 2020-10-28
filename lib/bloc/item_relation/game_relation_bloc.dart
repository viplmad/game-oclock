import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class GameRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Game, W> {
  GameRelationBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
    @required GameRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case DLC:
        return iCollectionRepository.getDLCsFromGame(itemId) as Stream<List<W>>;
      case Purchase:
        return iCollectionRepository.getPurchasesFromGame(itemId) as Stream<List<W>>;
      case Platform:
        return iCollectionRepository.getPlatformsFromGame(itemId) as Stream<List<W>>;
      case Tag:
        return iCollectionRepository.getTagsFromGame(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}

class FinishDateRelationBloc extends RelationBloc<Game, DateTime> {
  FinishDateRelationBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
    @required FinishGameRelationManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<DateTime>> getRelationStream() {

    return iCollectionRepository.getFinishDatesFromGame(itemId);

  }
}