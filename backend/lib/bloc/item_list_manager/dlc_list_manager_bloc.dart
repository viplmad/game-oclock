import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

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