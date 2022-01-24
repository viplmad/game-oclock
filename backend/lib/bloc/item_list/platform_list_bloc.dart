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
  Future<List<Platform>> getReadAllStream([int? page]) {

    final Future<List<PlatformEntity>> entityListFuture = repository.findAllWithView(PlatformView.main, page);
    return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Platform>> getReadViewStream(int viewIndex, [int? page]) {

    final PlatformView view = PlatformView.values[viewIndex];
    final Future<List<PlatformEntity>> entityListFuture = repository.findAllWithView(view, page);
    return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}