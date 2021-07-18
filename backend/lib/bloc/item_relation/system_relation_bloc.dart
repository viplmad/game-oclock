import 'dart:async';

import 'package:backend/model/model.dart' show Item, System, Platform;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class SystemRelationBloc<W extends Item> extends ItemRelationBloc<System, W> {
  SystemRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required SystemRelationManagerBloc<W> managerBloc,
  }) :
    this.platformRepository = collectionRepository.platformRepository,
    super(itemId: itemId, managerBloc: managerBloc);

  final PlatformRepository platformRepository;

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Platform:
        return platformRepository.findAllPlatformsFromSystem(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}