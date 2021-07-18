import 'dart:async';

import 'package:backend/model/model.dart' show Item, Platform, Game, System;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository, SystemRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class PlatformRelationBloc<W extends Item> extends ItemRelationBloc<Platform, W> {
  PlatformRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required PlatformRelationManagerBloc<W> managerBloc,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    this.systemRepository = collectionRepository.systemRepository,
    super(itemId: itemId, managerBloc: managerBloc);

  final GameRepository gameRepository;
  final SystemRepository systemRepository;

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return gameRepository.findAllGamesFromPlatform(itemId) as Stream<List<W>>;
      case System:
        return systemRepository.findAllSystemsFromPlatform(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}