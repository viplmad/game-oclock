import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformID, PlatformView;
import 'package:backend/model/model.dart' show Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_search.dart';


class PlatformSearchBloc extends ItemRemoteSearchBloc<Platform, PlatformEntity, PlatformID, PlatformRepository> {
  PlatformSearchBloc({
    required GameCollectionRepository collectionRepository,
    required int? viewIndex,
  }) : super(repository: collectionRepository.platformRepository, viewIndex: viewIndex);

  @override
  Future<List<Platform>> getInitialItems() {

    final PlatformView view = viewIndex != null? PlatformView.values[viewIndex!] : PlatformView.lastCreated;
    final Future<List<PlatformEntity>> entityListFuture = repository.findFirstWithView(view, super.maxSuggestions);
    return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Platform>> getSearchItems(String query) {

    if(viewIndex != null) {
      final PlatformView view = PlatformView.values[viewIndex!];
      final Future<List<PlatformEntity>> entityListFuture = repository.findFirstWithViewByName(view, query, super.maxResults);
      return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);
    } else {
      final Future<List<PlatformEntity>> entityListFuture = repository.findFirstByName(query, super.maxResults);
      return PlatformMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);
    }

  }
}