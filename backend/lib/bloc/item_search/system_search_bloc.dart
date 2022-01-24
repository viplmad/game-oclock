import 'package:backend/entity/entity.dart' show SystemEntity, SystemID, SystemView;
import 'package:backend/model/model.dart' show System;
import 'package:backend/mapper/mapper.dart' show SystemMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import 'item_search.dart';


class SystemSearchBloc extends ItemRemoteSearchBloc<System, SystemEntity, SystemID, SystemRepository> {
  SystemSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.systemRepository);

  @override
  Future<List<System>> getInitialItems() {

    final Future<List<SystemEntity>> entityListFuture = repository.findFirstWithView(SystemView.lastCreated, super.maxSuggestions);
    return SystemMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<System>> getSearchItems(String query) {

    final Future<List<SystemEntity>> entityListFuture = repository.findFirstByName(query, super.maxResults);
    return SystemMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}