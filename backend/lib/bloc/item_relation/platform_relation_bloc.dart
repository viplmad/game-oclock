import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart' show Item, Platform, Game, System;
import 'package:backend/mapper/mapper.dart';
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameRepository, SystemRepository;

import 'item_relation.dart';

class PlatformRelationBloc<W extends Item>
    extends ItemRelationBloc<Platform, PlatformID, W> {
  PlatformRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required super.managerBloc,
  })  : gameRepository = collectionRepository.gameRepository,
        systemRepository = collectionRepository.systemRepository,
        super(
          id: PlatformID(itemId),
          collectionRepository: collectionRepository,
        );

  final GameRepository gameRepository;
  final SystemRepository systemRepository;

  @override
  Future<List<W>> getRelationItems() {
    switch (W) {
      case Game:
        final Future<List<GameEntity>> entityListFuture =
            gameRepository.findAllFromPlatform(id);
        return GameMapper.futureEntityListToModelList(
          entityListFuture,
          gameRepository.getImageURI,
        ) as Future<List<W>>;
      case System:
        final Future<List<SystemEntity>> entityListFuture =
            systemRepository.findAllFromPlatform(id);
        return SystemMapper.futureEntityListToModelList(
          entityListFuture,
          systemRepository.getImageURI,
        ) as Future<List<W>>;
    }

    return super.getRelationItems();
  }
}
