import 'package:backend/model/model.dart' show Store;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import 'item_list_manager.dart';


class StoreListManagerBloc extends ItemListManagerBloc<Store, StoreRepository> {
  StoreListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.storeRepository);
}