import 'package:game_oclock_client/api.dart' show GameDTO, PlatformAvailableDTO;

import 'package:logic/model/model.dart' show ItemFinish;
import 'package:logic/service/service.dart'
    show GameOClockService, DLCService, DLCFinishService;

import 'item_relation_manager.dart';

class DLCFinishRelationManagerBloc
    extends ItemRelationManagerBloc<ItemFinish, DateTime> {
  DLCFinishRelationManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  })  : _dlcFinishService = collectionService.dlcFinishService,
        super();

  final DLCFinishService _dlcFinishService;

  @override
  Future<void> addRelation(AddItemRelation<DateTime> event) {
    return _dlcFinishService.create(itemId, event.otherItem);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<ItemFinish> event) {
    return _dlcFinishService.delete(itemId, event.otherItem.date);
  }
}

class DLCGameRelationManagerBloc
    extends ItemRelationManagerBloc<GameDTO, GameDTO> {
  DLCGameRelationManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  })  : _dlcService = collectionService.dlcService,
        super();

  final DLCService _dlcService;

  @override
  Future<void> addRelation(AddItemRelation<GameDTO> event) {
    return _dlcService.setBasegame(itemId, event.otherItem.id);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<GameDTO> event) {
    return _dlcService.clearBasegame(itemId);
  }
}

class DLCPlatformRelationManagerBloc extends ItemRelationManagerBloc<
    PlatformAvailableDTO, PlatformAvailableDTO> {
  DLCPlatformRelationManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  })  : _dlcService = collectionService.dlcService,
        super();

  final DLCService _dlcService;

  @override
  Future<void> addRelation(AddItemRelation<PlatformAvailableDTO> event) {
    return _dlcService.addAvailability(
      itemId,
      event.otherItem.id,
      event.otherItem.availableDate,
    );
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<PlatformAvailableDTO> event) {
    return _dlcService.removeAvailability(itemId, event.otherItem.id);
  }
}
