import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class PlatformRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Platform, W> {
  PlatformRelationBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required PlatformRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.findAllGamesFromPlatform(itemId) as Stream<List<W>>;
      case System:
        return iCollectionRepository.findAllSystemsFromPlatform(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}