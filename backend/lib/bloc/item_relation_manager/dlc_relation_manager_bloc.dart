import 'package:game_collection_client/api.dart'
    show GameDTO, PlatformAvailableDTO;

import 'package:logic/model/model.dart' show ItemFinish;
import 'package:logic/service/service.dart'
    show GameCollectionService, DLCService, DLCFinishService;

import 'item_relation_manager.dart';

class DLCFinishRelationManagerBloc extends ItemRelationManagerBloc<ItemFinish> {
  DLCFinishRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : dlcFinishService = collectionService.dlcFinishService,
        super();

  final DLCFinishService dlcFinishService;

  @override
  Future<void> addRelation(AddItemRelation<ItemFinish> event) {
    return dlcFinishService.create(itemId, event.otherItem.date);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<ItemFinish> event) {
    return dlcFinishService.delete(itemId, event.otherItem.date);
  }
}

class DLCGameRelationManagerBloc extends ItemRelationManagerBloc<GameDTO> {
  DLCGameRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : dlcService = collectionService.dlcService,
        super();

  final DLCService dlcService;

  @override
  Future<void> addRelation(AddItemRelation<GameDTO> event) {
    return dlcService.setBasegame(itemId, event.otherItem.id);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<GameDTO> event) {
    return dlcService.clearBasegame(itemId);
  }
}

class DLCPlatformRelationManagerBloc
    extends ItemRelationManagerBloc<PlatformAvailableDTO> {
  DLCPlatformRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : dlcService = collectionService.dlcService,
        super();

  final DLCService dlcService;

  @override
  Future<void> addRelation(AddItemRelation<PlatformAvailableDTO> event) {
    return dlcService.addAvailability(
      itemId,
      event.otherItem.id,
      event.otherItem.availableDate,
    );
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<PlatformAvailableDTO> event) {
    return dlcService.removeAvailability(itemId, event.otherItem.id);
  }
}
