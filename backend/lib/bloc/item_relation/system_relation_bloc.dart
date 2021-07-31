import 'package:backend/entity/entity.dart' show PlatformEntity, SystemID;
import 'package:backend/model/model.dart' show Item, System, Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class SystemRelationBloc<W extends Item> extends ItemRelationBloc<System, SystemID, W> {
  SystemRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required SystemRelationManagerBloc<W> managerBloc,
  }) :
    this.platformRepository = collectionRepository.platformRepository,
    super(id: SystemID(itemId), collectionRepository: collectionRepository, managerBloc: managerBloc);

  final PlatformRepository platformRepository;

  @override
  Future<List<W>> getRelationStream() {

    switch(W) {
      case Platform:
        final Future<List<PlatformEntity>> entityListFuture = platformRepository.findAllFromSystem(id);
        return PlatformMapper.futureEntityListToModelList(entityListFuture, platformRepository.getImageURI) as Future<List<W>>;
    }

    return super.getRelationStream();

  }
}