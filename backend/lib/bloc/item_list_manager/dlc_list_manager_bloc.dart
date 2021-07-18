import 'package:backend/model/model.dart' show DLC;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import 'item_list_manager.dart';


class DLCListManagerBloc extends ItemListManagerBloc<DLC, DLCRepository> {
  DLCListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.dlcRepository);
}