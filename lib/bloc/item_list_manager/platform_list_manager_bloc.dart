import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class PlatformListManagerBloc extends ItemListManagerBloc<Platform> {

  PlatformListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Platform> createFuture(AddItem event) {

    return iCollectionRepository.insertPlatform(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Platform> event) {

    return iCollectionRepository.deletePlatform(event.item.ID);

  }

}