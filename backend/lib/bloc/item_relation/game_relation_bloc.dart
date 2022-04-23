import 'package:backend/entity/entity.dart'
    show
        DLCEntity,
        GameFinishEntity,
        GameID,
        GameTagEntity,
        PlatformEntity,
        PurchaseEntity;
import 'package:backend/model/model.dart'
    show DLC, Game, GameFinish, Item, Platform, Purchase, GameTag;
import 'package:backend/mapper/mapper.dart'
    show
        DLCMapper,
        GameFinishMapper,
        GameTagMapper,
        PlatformMapper,
        PurchaseMapper;
import 'package:backend/repository/repository.dart'
    show
        DLCRepository,
        GameCollectionRepository,
        GameFinishRepository,
        GameTagRepository,
        PlatformRepository,
        PurchaseRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';

class GameRelationBloc<W extends Item>
    extends ItemRelationBloc<Game, GameID, W> {
  GameRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required GameRelationManagerBloc<W> managerBloc,
  })  : gameFinishRepository = collectionRepository.gameFinishRepository,
        dlcRepository = collectionRepository.dlcRepository,
        platformRepository = collectionRepository.platformRepository,
        purchaseRepository = collectionRepository.purchaseRepository,
        gameTagRepository = collectionRepository.gameTagRepository,
        super(
          id: GameID(itemId),
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        );

  final GameFinishRepository gameFinishRepository;
  final DLCRepository dlcRepository;
  final PlatformRepository platformRepository;
  final PurchaseRepository purchaseRepository;
  final GameTagRepository gameTagRepository;

  @override
  Future<List<W>> getRelationItems() {
    switch (W) {
      case GameFinish:
        final Future<List<GameFinishEntity>> entityListFuture =
            gameFinishRepository.findAllFromGame(id);
        return GameFinishMapper.futureEntityListToModelList(entityListFuture)
            as Future<List<W>>;
      case DLC:
        final Future<List<DLCEntity>> entityListFuture =
            dlcRepository.findAllFromGame(id);
        return DLCMapper.futureEntityListToModelList(
          entityListFuture,
          dlcRepository.getImageURI,
        ) as Future<List<W>>;
      case Platform:
        final Future<List<PlatformEntity>> entityListFuture =
            platformRepository.findAllFromGame(id);
        return PlatformMapper.futureEntityListToModelList(
          entityListFuture,
          platformRepository.getImageURI,
        ) as Future<List<W>>;
      case Purchase:
        final Future<List<PurchaseEntity>> entityListFuture =
            purchaseRepository.findAllFromGame(id);
        return PurchaseMapper.futureEntityListToModelList(entityListFuture)
            as Future<List<W>>;
      case GameTag:
        final Future<List<GameTagEntity>> entityListFuture =
            gameTagRepository.findAllFromGame(id);
        return GameTagMapper.futureEntityListToModelList(entityListFuture)
            as Future<List<W>>;
    }

    return super.getRelationItems();
  }
}
