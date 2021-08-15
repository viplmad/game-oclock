import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformID;
import 'package:backend/model/model.dart' show Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class PlatformDetailBloc extends ItemDetailBloc<Platform, PlatformEntity, PlatformID, PlatformRepository> {
  PlatformDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required PlatformDetailManagerBloc managerBloc,
  }) : super(id: PlatformID(itemId), repository: collectionRepository.platformRepository, managerBloc: managerBloc);

  @override
  Future<Platform> getReadFuture() {

    final Future<PlatformEntity> entityFuture = repository.findById(id);
    return PlatformMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }
}