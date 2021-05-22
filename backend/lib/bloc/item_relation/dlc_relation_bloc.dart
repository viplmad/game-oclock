import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class DLCRelationBloc<W extends CollectionItem> extends ItemRelationBloc<DLC, W> {
  DLCRelationBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required DLCRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.findBaseGameFromDLC(itemId).map<List<Game>>( (Game? game) => game != null? <Game>[game] : <Game>[] ) as Stream<List<W>>;
      case Purchase:
        return iCollectionRepository.findAllPurchasesFromDLC(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}

class DLCFinishRelationBloc extends RelationBloc<DLC, DLCFinish> {
  DLCFinishRelationBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required DLCFinishRelationManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<DLCFinish>> getRelationStream() {

    return iCollectionRepository.findAllDLCFinishFromDLC(itemId);

  }
}