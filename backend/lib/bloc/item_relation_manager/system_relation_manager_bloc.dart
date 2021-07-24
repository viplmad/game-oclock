import 'package:backend/entity/entity.dart' show PlatformEntity, SystemID;
import 'package:backend/model/model.dart' show Item, System, Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_relation_manager.dart';


class SystemRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<System, SystemID, W> {
  SystemRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.platformRepository = collectionRepository.platformRepository,
    super(id: SystemID(itemId));

  final PlatformRepository platformRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Platform:
        final PlatformEntity otherEntity = PlatformMapper.modelToEntity(otherItem as Platform);
        return platformRepository.relatePlatformSystem(otherEntity.createId(), id);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Platform:
        final PlatformEntity otherEntity = PlatformMapper.modelToEntity(otherItem as Platform);
        return platformRepository.unrelatePlatformSystem(otherEntity.createId(), id);
    }

    return super.deleteRelationFuture(event);

  }
}