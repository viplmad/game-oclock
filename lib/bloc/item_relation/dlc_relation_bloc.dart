import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class DLCRelationBloc<W extends CollectionItem> extends ItemRelationBloc<DLC, W> {

  DLCRelationBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
    @required DLCRelationManagerBloc<W> managerBloc,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.getBaseGameFromDLC(itemID).map<List<Game>>( (Game game) => game != null? [game] : [] ) as Stream<List<W>>;
      case Purchase:
        return iCollectionRepository.getPurchasesFromDLC(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}