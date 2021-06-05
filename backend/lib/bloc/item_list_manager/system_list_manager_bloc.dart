import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_list_manager.dart';


class SystemListManagerBloc extends ItemListManagerBloc<System> {
  SystemListManagerBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<System?> createFuture(AddItem<System> event) {

    return iCollectionRepository.createSystem(event.item);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<System> event) {

    return iCollectionRepository.deleteSystemById(event.item.id);

  }
}