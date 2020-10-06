import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class TypeRelationBloc<W extends CollectionItem> extends ItemRelationBloc<PurchaseType, W> {

  TypeRelationBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
    @required TypeRelationManagerBloc<W> managerBloc,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        return iCollectionRepository.getPurchasesFromType(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}