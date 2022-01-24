import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformID, PlatformView;
import 'package:backend/model/model.dart' show Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_search.dart';


class PlatformSearchBloc extends ItemRemoteSearchBloc<Platform, PlatformEntity, PlatformID, PlatformRepository> {
  PlatformSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.platformRepository);

  @override
  Future<List<Platform>> getInitialItems() {

    final Future<List<PlatformEntity>> entityListFuture = repository.findFirstWithView(PlatformView.lastCreated, super.maxSuggestions);
    return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Platform>> getSearchItems(String query) {

    final Future<List<PlatformEntity>> entityListFuture = repository.findFirstByName(query, super.maxResults);
    return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}