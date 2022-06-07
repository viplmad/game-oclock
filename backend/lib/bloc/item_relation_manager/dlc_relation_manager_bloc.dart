import 'package:backend/entity/entity.dart'
    show DLCFinishEntity, GameEntity, PurchaseEntity, DLCID;
import 'package:backend/model/model.dart'
    show Item, DLC, DLCFinish, Game, Purchase;
import 'package:backend/mapper/mapper.dart'
    show DLCFinishMapper, GameMapper, PurchaseMapper;
import 'package:backend/repository/repository.dart'
    show
        DLCRepository,
        DLCFinishRepository,
        GameRepository;

import 'item_relation_manager.dart';

class DLCRelationManagerBloc<W extends Item>
    extends ItemRelationManagerBloc<DLC, DLCID, W> {
  DLCRelationManagerBloc({
    required int itemId,
    required super.collectionRepository,
  })  : dlcFinishRepository = collectionRepository.dlcFinishRepository,
        gameRepository = collectionRepository.gameRepository,
        dlcRepository = collectionRepository.dlcRepository,
        super(id: DLCID(itemId));

  final DLCFinishRepository dlcFinishRepository;
  final GameRepository gameRepository;
  final DLCRepository dlcRepository;

  @override
  Future<Object?> addRelation(AddItemRelation<W> event) {
    final W otherItem = event.otherItem;

    switch (W) {
      case DLCFinish:
        final DLCFinishEntity otherEntity =
            DLCFinishMapper.modelToEntity(id.id, otherItem as DLCFinish);
        return dlcFinishRepository.create(otherEntity);
      case Game:
        final GameEntity otherEntity =
            GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.relateGameDLC(otherEntity.createId(), id);
      case Purchase:
        final PurchaseEntity otherEntity =
            PurchaseMapper.modelToEntity(otherItem as Purchase);
        return dlcRepository.relateDLCPurchase(id, otherEntity.createId());
    }

    return super.addRelation(event);
  }

  @override
  Future<Object?> deleteRelation(DeleteItemRelation<W> event) {
    final W otherItem = event.otherItem;

    switch (W) {
      case DLCFinish:
        final DLCFinishEntity otherEntity =
            DLCFinishMapper.modelToEntity(id.id, otherItem as DLCFinish);
        return dlcFinishRepository.deleteById(otherEntity.createId());
      case Game:
        return gameRepository.unrelateGameDLC(id);
      case Purchase:
        final PurchaseEntity otherEntity =
            PurchaseMapper.modelToEntity(otherItem as Purchase);
        return dlcRepository.unrelateDLCPurchase(id, otherEntity.createId());
    }

    return super.deleteRelation(event);
  }
}
