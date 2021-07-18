import 'package:backend/model/model.dart' show Store;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class StoreDetailBloc extends ItemDetailBloc<Store, StoreRepository> {
  StoreDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required StoreDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, repository: collectionRepository.storeRepository, managerBloc: managerBloc);
}