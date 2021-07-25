import 'package:backend/entity/entity.dart' show DLCEntity, DLCID, DLCView;
import 'package:backend/model/model.dart' show DLC;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import 'item_search.dart';


class DLCSearchBloc extends ItemRemoteSearchBloc<DLC, DLCEntity, DLCID, DLCRepository> {
  DLCSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.dlcRepository);

  @override
  Future<List<DLC>> getInitialItems() {

    final Future<List<DLCEntity>> entityListFuture = repository.findAllWithView(DLCView.LastCreated, super.maxSuggestions);
    return DLCMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<DLC>> getSearchItems(String query) {

    final Future<List<DLCEntity>> entityListFuture = repository.findAllByName(query, super.maxResults);
    return DLCMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}