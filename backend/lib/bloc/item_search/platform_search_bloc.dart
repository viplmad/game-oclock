import 'package:backend/model/model.dart' show Platform, PlatformView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_search.dart';


class PlatformSearchBloc extends ItemRemoteSearchBloc<Platform, PlatformRepository> {
  PlatformSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.platformRepository);

  @override
  Future<List<Platform>> getInitialItems() {

    return repository.findAllPlatformsWithView(PlatformView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Platform>> getSearchItems(String query) {

    return repository.findAllPlatformsByName(query, super.maxResults).first;

  }
}