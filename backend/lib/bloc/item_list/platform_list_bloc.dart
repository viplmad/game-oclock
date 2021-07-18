import 'package:backend/model/model.dart' show Platform, PlatformView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class PlatformListBloc extends ItemListBloc<Platform, PlatformRepository> {
  PlatformListBloc({
    required GameCollectionRepository collectionRepository,
    required PlatformListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.platformRepository, managerBloc: managerBloc);

  @override
  Stream<List<Platform>> getReadViewStream(UpdateView event) {

    final PlatformView platformView = PlatformView.values[event.viewIndex];

    return repository.findAllPlatformsWithView(platformView);

  }
}