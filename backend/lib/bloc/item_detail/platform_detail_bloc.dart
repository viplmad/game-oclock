import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformID;
import 'package:backend/model/model.dart' show Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, PlatformRepository;

import 'item_detail.dart';

class PlatformDetailBloc extends ItemDetailBloc<Platform, PlatformEntity,
    PlatformID, PlatformRepository> {
  PlatformDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required super.managerBloc,
  }) : super(
          id: PlatformID(itemId),
          repository: collectionRepository.platformRepository,
        );

  @override
  Future<Platform> get() {
    final Future<PlatformEntity> entityFuture = repository.findById(id);
    return PlatformMapper.futureEntityToModel(
      entityFuture,
      repository.getImageURI,
    );
  }
}
