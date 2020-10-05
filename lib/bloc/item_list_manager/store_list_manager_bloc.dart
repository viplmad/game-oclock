import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class StoreListManagerBloc extends ItemListManagerBloc<Store> {

  StoreListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Store> createFuture(AddItem event) {

    return iCollectionRepository.insertStore(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Store> event) {

    return iCollectionRepository.deleteStore(event.item.ID);

  }

}