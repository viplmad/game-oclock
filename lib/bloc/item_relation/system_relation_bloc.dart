import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class SystemRelationBloc<W extends CollectionItem> extends ItemRelationBloc<System, W> {
  SystemRelationBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required SystemRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Platform:
        return iCollectionRepository.getPlatformsFromSystem(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}