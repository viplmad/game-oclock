import 'package:backend/entity/entity.dart'
    show PlatformEntity, PlatformID, PlatformView;
import 'package:backend/model/model.dart' show Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, PlatformRepository;

import 'item_list.dart';

class PlatformListBloc extends ItemListBloc<Platform, PlatformEntity,
    PlatformID, PlatformRepository> {
  PlatformListBloc({
    required GameCollectionRepository collectionRepository,
    required super.managerBloc,
  }) : super(repository: collectionRepository.platformRepository);

  @override
  Future<ViewParameters> getStartViewIndex() {
    return Future<ViewParameters>.value(
      ViewParameters(PlatformView.main.index),
    );
  }

  @override
  Future<List<Platform>> getAllWithView(int viewIndex, [int? page]) {
    final PlatformView view = PlatformView.values[viewIndex];
    final Future<List<PlatformEntity>> entityListFuture =
        repository.findAllWithView(view, page);
    return PlatformMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }
}
