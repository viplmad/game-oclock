import 'package:backend/entity/entity.dart' show DLCFinishEntity, DLCID, GameEntity, PurchaseEntity;
import 'package:backend/model/model.dart' show Item, DLC, DLCFinish, Game, Purchase;
import 'package:backend/mapper/mapper.dart' show DLCFinishMapper, GameMapper, PurchaseMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCFinishRepository, GameRepository, PurchaseRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class DLCRelationBloc<W extends Item> extends ItemRelationBloc<DLC, DLCID, W> {
  DLCRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required DLCRelationManagerBloc<W> managerBloc,
  }) :
    this.dlcFinishRepository = collectionRepository.dlcFinishRepository,
    this.gameRepository = collectionRepository.gameRepository,
    this.purchaseRepository = collectionRepository.purchaseRepository,
    super(id: DLCID(itemId), managerBloc: managerBloc);

  final DLCFinishRepository dlcFinishRepository;
  final GameRepository gameRepository;
  final PurchaseRepository purchaseRepository;

  @override
  Future<List<W>> getRelationStream() {

    switch(W) {
      case DLCFinish:
        final Future<List<DLCFinishEntity>> entityListFuture = dlcFinishRepository.findAllDLCFinishFromDLC(id);
        return DLCFinishMapper.futureEntityListToModelList(entityListFuture) as Future<List<W>>;
      case Game:
        final Future<GameEntity> entityFuture = gameRepository.findBaseGameFromDLC(id); // TODO can be null game != null? <Game>[game] : <Game>[]
        return GameMapper.futureEntityToModel(entityFuture, gameRepository.getImageURI) as Future<List<W>>;
      case Purchase:
        final Future<List<PurchaseEntity>> entityListFuture = purchaseRepository.findAllPurchasesFromDLC(id);
        return PurchaseMapper.futureEntityListToModelList(entityListFuture) as Future<List<W>>;
    }

    return super.getRelationStream();

  }
}