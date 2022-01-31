import 'package:backend/entity/entity.dart' show SystemEntity, SystemID, SystemView;
import 'package:backend/model/model.dart' show System;
import 'package:backend/mapper/mapper.dart' show SystemMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import 'item_search.dart';


class SystemSearchBloc extends ItemRemoteSearchBloc<System, SystemEntity, SystemID, SystemRepository> {
  SystemSearchBloc({
    required GameCollectionRepository collectionRepository,
    required int? viewIndex,
  }) : super(repository: collectionRepository.systemRepository, viewIndex: viewIndex);

  @override
  Future<List<System>> getInitialItems() {

    final SystemView view = viewIndex != null? SystemView.values[viewIndex!] : SystemView.lastCreated;
    final Future<List<SystemEntity>> entityListFuture = repository.findFirstWithView(view, super.maxSuggestions);
    return SystemMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<System>> getSearchItems(String query) {

    if(viewIndex != null) {
      final SystemView view = SystemView.values[viewIndex!];
      final Future<List<SystemEntity>> entityListFuture = repository.findFirstWithViewByName(view, query, super.maxResults);
      return SystemMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);
    } else {
      final Future<List<SystemEntity>> entityListFuture = repository.findFirstByName(query, super.maxResults);
      return SystemMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);
    }

  }
}