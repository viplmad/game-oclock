import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformID, PlatformView;
import 'package:backend/model/model.dart' show Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class PlatformListBloc extends ItemListBloc<Platform, PlatformEntity, PlatformID, PlatformRepository> {
  PlatformListBloc({
    required GameCollectionRepository collectionRepository,
    required PlatformListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.platformRepository, managerBloc: managerBloc);

  @override
  Future<List<Platform>> getReadAllStream() {

    final Future<List<PlatformEntity>> entityListFuture = repository.findAllPlatformsWithView(PlatformView.Main);
    return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Platform>> getReadViewStream(UpdateView event) {

    final PlatformView view = PlatformView.values[event.viewIndex];
    final Future<List<PlatformEntity>> entityListFuture = repository.findAllPlatformsWithView(view);
    return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}