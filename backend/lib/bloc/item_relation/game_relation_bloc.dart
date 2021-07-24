import 'package:backend/entity/entity.dart' show DLCEntity, GameFinishEntity, GameID, GameTagEntity, PlatformEntity, PurchaseEntity;
import 'package:backend/model/model.dart' show DLC, Game, GameFinish, Item, Platform, Purchase, Tag;
import 'package:backend/mapper/mapper.dart' show DLCMapper, GameFinishMapper, GameTagMapper, PlatformMapper, PurchaseMapper;
import 'package:backend/repository/repository.dart' show DLCRepository, GameCollectionRepository, GameFinishRepository, GameTagRepository, PlatformRepository, PurchaseRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class GameRelationBloc<W extends Item> extends ItemRelationBloc<Game, GameID, W> {
  GameRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required GameRelationManagerBloc<W> managerBloc,
  }) :
    this.gameFinishRepository = collectionRepository.gameFinishRepository,
    this.dlcRepository = collectionRepository.dlcRepository,
    this.platformRepository = collectionRepository.platformRepository,
    this.purchaseRepository = collectionRepository.purchaseRepository,
    this.gameTagRepository = collectionRepository.gameTagRepository,
    super(id: GameID(itemId), managerBloc: managerBloc);

  final GameFinishRepository gameFinishRepository;
  final DLCRepository dlcRepository;
  final PlatformRepository platformRepository;
  final PurchaseRepository purchaseRepository;
  final GameTagRepository gameTagRepository;

  @override
  Future<List<W>> getRelationStream() {

    switch(W) {
      case GameFinish:
        final Future<List<GameFinishEntity>> entityListFuture = gameFinishRepository.findAllGameFinishFromGame(id);
        return GameFinishMapper.futureEntityListToModelList(entityListFuture) as Future<List<W>>;
      case DLC:
        final Future<List<DLCEntity>> entityListFuture = dlcRepository.findAllFromGame(id);
        return DLCMapper.futureEntityListToModelList(entityListFuture, dlcRepository.getImageURI) as Future<List<W>>;
      case Platform:
        final Future<List<PlatformEntity>> entityListFuture = platformRepository.findAllPlatformsFromGame(id);
        return PlatformMapper.futureEntityListToModelList(entityListFuture, platformRepository.getImageURI) as Future<List<W>>;
      case Purchase:
        final Future<List<PurchaseEntity>> entityListFuture =  purchaseRepository.findAllPurchasesFromGame(id);
        return PurchaseMapper.futureEntityListToModelList(entityListFuture) as Future<List<W>>;
      case Tag:
        final Future<List<GameTagEntity>> entityListFuture = gameTagRepository.findAllGameTagsFromGame(id);
        return GameTagMapper.futureEntityListToModelList(entityListFuture) as Future<List<W>>;
    }

    return super.getRelationStream();

  }
}