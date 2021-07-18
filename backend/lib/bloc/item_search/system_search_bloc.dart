import 'package:backend/model/model.dart' show System, SystemView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import 'item_search.dart';


class SystemSearchBloc extends ItemRemoteSearchBloc<System, SystemRepository> {
  SystemSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.systemRepository);

  @override
  Future<List<System>> getInitialItems() {

    return repository.findAllSystemsWithView(SystemView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<System>> getSearchItems(String query) {

    return repository.findAllSystemsByName(query, super.maxResults).first;

  }
}