import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class StoreListManagerBloc extends ItemListManagerBloc<Store> {
  StoreListManagerBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Store?> createFuture(AddItem<Store> event) {

    return iCollectionRepository.createStore(event.item);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Store> event) {

    return iCollectionRepository.deleteStoreById(event.item.id);

  }
}