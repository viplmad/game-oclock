import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class StoreRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Store, W> {
  StoreRelationBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
    @required StoreRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        return iCollectionRepository.getPurchasesFromStore(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}