import 'package:backend/entity/entity.dart' show DLCEntity, DLCID, DLCView;
import 'package:backend/model/model.dart' show DLC;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, DLCRepository;

import 'item_search.dart';

class DLCSearchBloc
    extends ItemRemoteSearchBloc<DLC, DLCEntity, DLCID, DLCRepository> {
  DLCSearchBloc({
    required GameCollectionRepository collectionRepository,
    required super.viewIndex,
  }) : super(repository: collectionRepository.dlcRepository);

  @override
  Future<List<DLC>> getInitialItems() {
    final DLCView view =
        viewIndex != null ? DLCView.values[viewIndex!] : DLCView.lastCreated;
    final Future<List<DLCEntity>> entityListFuture =
        repository.findFirstWithView(view, super.maxSuggestions);
    return DLCMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }

  @override
  Future<List<DLC>> getSearchItems(String query) {
    if (viewIndex != null) {
      final DLCView view = DLCView.values[viewIndex!];
      final Future<List<DLCEntity>> entityListFuture =
          repository.findFirstWithViewByName(view, query, super.maxResults);
      return DLCMapper.futureEntityListToModelList(
        entityListFuture,
        repository.getImageURI,
      );
    } else {
      final Future<List<DLCEntity>> entityListFuture =
          repository.findFirstByName(query, super.maxResults);
      return DLCMapper.futureEntityListToModelList(
        entityListFuture,
        repository.getImageURI,
      );
    }
  }
}
