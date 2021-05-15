import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class SystemListManagerBloc extends ItemListManagerBloc<System> {
  SystemListManagerBloc({
    required ICollectionRepository iCollectionRepository,
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