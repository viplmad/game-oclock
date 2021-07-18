import 'package:backend/model/model.dart' show DLC;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class DLCDetailBloc extends ItemDetailBloc<DLC, DLCRepository> {
  DLCDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required DLCDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, repository: collectionRepository.dlcRepository, managerBloc: managerBloc);
}