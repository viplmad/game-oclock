import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class DLCListManagerBloc extends ItemListManagerBloc<DLC> {
  DLCListManagerBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<DLC?> createFuture(AddItem<DLC> event) {

    return iCollectionRepository.createDLC(event.item);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<DLC> event) {

    return iCollectionRepository.deleteDLCById(event.item.id);

  }
}