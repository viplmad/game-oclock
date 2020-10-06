import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class GameRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Game, W> {

  GameRelationBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
    @required GameRelationManagerBloc<W> managerBloc,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case DLC:
        return iCollectionRepository.getDLCsFromGame(itemID) as Stream<List<W>>;
      case Purchase:
        return iCollectionRepository.getPurchasesFromGame(itemID) as Stream<List<W>>;
      case Platform:
        return iCollectionRepository.getPlatformsFromGame(itemID) as Stream<List<W>>;
      case Tag:
        return iCollectionRepository.getTagsFromGame(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}