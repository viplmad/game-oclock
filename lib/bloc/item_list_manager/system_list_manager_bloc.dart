import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class SystemListManagerBloc extends ItemListManagerBloc<System> {

  SystemListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<System> createFuture(AddItem event) {

    return iCollectionRepository.createSystem(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<System> event) {

    return iCollectionRepository.deleteSystem(event.item.id);

  }

}