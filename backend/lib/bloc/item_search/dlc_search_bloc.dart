import 'package:backend/model/model.dart' show DLC, DLCView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import 'item_search.dart';


class DLCSearchBloc extends ItemRemoteSearchBloc<DLC, DLCRepository> {
  DLCSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.dlcRepository);

  @override
  Future<List<DLC>> getInitialItems() {

    return repository.findAllDLCsWithView(DLCView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<DLC>> getSearchItems(String query) {

    return repository.findAllDLCsByName(query, super.maxResults).first;

  }
}