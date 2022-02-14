import 'package:backend/entity/entity.dart'
    show DLCEntity, GameEntity, PurchaseID, PurchaseTypeEntity, StoreEntity;
import 'package:backend/model/model.dart'
    show Item, Purchase, Game, DLC, Store, PurchaseType;
import 'package:backend/mapper/mapper.dart'
    show DLCMapper, GameMapper, PurchaseTypeMapper, StoreMapper;
import 'package:backend/repository/repository.dart'
    show
        GameCollectionRepository,
        GameRepository,
        DLCRepository,
        PurchaseTypeRepository,
        StoreRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';

class PurchaseRelationBloc<W extends Item>
    extends ItemRelationBloc<Purchase, PurchaseID, W> {
  PurchaseRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required PurchaseRelationManagerBloc<W> managerBloc,
  })  : gameRepository = collectionRepository.gameRepository,
        dlcRepository = collectionRepository.dlcRepository,
        storeRepository = collectionRepository.storeRepository,
        purchaseTypeRepository = collectionRepository.purchaseTypeRepository,
        super(
          id: PurchaseID(itemId),
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        );

  final GameRepository gameRepository;
  final DLCRepository dlcRepository;
  final StoreRepository storeRepository;
  final PurchaseTypeRepository purchaseTypeRepository;

  @override
  Future<List<W>> getRelationStream() {
    switch (W) {
      case Game:
        final Future<List<GameEntity>> entityListFuture =
            gameRepository.findAllFromPurchase(id);
        return GameMapper.futureEntityListToModelList(
          entityListFuture,
          gameRepository.getImageURI,
        ) as Future<List<W>>;
      case DLC:
        final Future<List<DLCEntity>> entityListFuture =
            dlcRepository.findAllFromPurchase(id);
        return DLCMapper.futureEntityListToModelList(
          entityListFuture,
          dlcRepository.getImageURI,
        ) as Future<List<W>>;
      case Store:
        final Future<StoreEntity?> entityFuture =
            storeRepository.findOneFromPurchase(id);
        return entityFuture
            .asStream()
            .map(
              (StoreEntity? entity) => entity != null
                  ? <Store>[
                      StoreMapper.entityToModel(
                        entity,
                        storeRepository.getImageURI(entity.iconFilename),
                      )
                    ]
                  : <Store>[],
            )
            .first as Future<List<W>>;
      case PurchaseType:
        final Future<List<PurchaseTypeEntity>> entityListFuture =
            purchaseTypeRepository.findAllFromPurchase(id);
        return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture)
            as Future<List<W>>;
    }

    return super.getRelationStream();
  }
}
